// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/app.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/domain/battery_issue_repository/battery_issue_repository.dart';
import 'package:dronebag/domain/battery_repository/battery_repository.dart';
import 'package:dronebag/domain/battery_station_repository/src/models/models.dart';
import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/domain/user_repository/src/models/models.dart';
import 'package:dronebag/pages/third_layer/fly_drone/fly_drone.dart';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/widgets.dart';

const List<String> listy = <String>['Practice', 'Mission'];

class StopFlightPage extends StatefulWidget {
  final Group group;
  final List<Drone> droneList;
  final UserData pilot;
  final String flightPurpose;
  const StopFlightPage({
    Key? key,
    required this.group,
    required this.droneList,
    required this.pilot,
    required this.flightPurpose,
  }) : super(key: key);

  @override
  State<StopFlightPage> createState() => _StopFlightPageState();
}

class _StopFlightPageState extends State<StopFlightPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController serial_numberController = TextEditingController();
  final TextEditingController batteryIssueDetailController =
      TextEditingController();
  final TextEditingController batteryCycleController = TextEditingController();
  final TextEditingController date_boughtController = TextEditingController();
  final double sizedBoxHight = 16;
  final user = FirebaseAuth.instance.currentUser!;
  String dropdownValue = listy.first;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: ThemeColors.scaffoldBgColor,
            title: Text(
              "Flight Details",
              style: GoogleFonts.poppins(
                color: ThemeColors.whiteTextColor,
                fontSize: FontSize.xxLarge,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(38),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "You started a Flight!",
                      style: GoogleFonts.poppins(
                        color: ThemeColors.whiteTextColor,
                        fontSize: FontSize.xxLarge,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Text(
                        "below are the flight details",
                        style: GoogleFonts.poppins(
                          color: ThemeColors.greyTextColor,
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.topLeft,
                    child: FutureBuilder<UserData?>(
                      future: fetchUser(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final user = snapshot.data!;
                          return RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: '${widget.droneList.map(
                                  (drone) => drone.name,
                                )}',
                                style: GoogleFonts.poppins(
                                  color: ThemeColors.whiteTextColor,
                                  fontSize: FontSize.medium,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: user.fullName,
                                style: GoogleFonts.poppins(
                                  color: ThemeColors.greyTextColor,
                                  fontSize: FontSize.medium,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ]),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Something went wrong! \n\n${snapshot}',
                              style: TextStyle(color: Colors.white));
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Text(
                          'Flight purpose:   ',
                          style: GoogleFonts.poppins(
                            color: ThemeColors.whiteTextColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        DropdownButton<String>(
                          elevation: 16,
                          style: GoogleFonts.poppins(
                            color: ThemeColors.greyTextColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w600,
                          ),
                          underline: Container(
                            height: 2,
                            color: ThemeColors.greyTextColor,
                          ),
                          items:
                              listy.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: dropdownValue,
                          onChanged: (String? value) {
                            setState(() {
                              dropdownValue = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 150),
                  Center(
                    child: SizedBox(
                      height: 160,
                      width: 160,
                      child: FittedBox(
                        child: FloatingActionButton(
                          backgroundColor: Colors.red,
                          onPressed: () {
                            droneList.clear();
                          },
                          child: Text(
                            'Stop Flight',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: ThemeColors.whiteTextColor,
                              fontSize: 6,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  void dropdownCallback(String? selectedvalue) {
    if (selectedvalue is String) {
      setState(() {
        dropdownValue = selectedvalue;
      });
    }
  }

//fetch group's drones list
  Stream<List<Drone>> fetchGroupDrones() {
    return FirebaseFirestore.instance
        .collection('groups/${widget.group.id}/drones')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Drone.fromJson(doc.data())).toList());
  }

  Future<UserData?> fetchUser() async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.email);
    final snapshot = await userDoc.get();
    if (snapshot.exists) {
      return UserData.fromJson(snapshot.data()!);
    }
  }
}
