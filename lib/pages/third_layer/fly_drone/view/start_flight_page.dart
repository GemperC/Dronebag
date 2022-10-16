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
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/widgets.dart';

const List<String> list = <String>['Practice', 'Mission'];

class StartFlightPage extends StatefulWidget {
  final Group group;
  const StartFlightPage({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  State<StartFlightPage> createState() => _StartFlightPageState();
}

class _StartFlightPageState extends State<StartFlightPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController serial_numberController = TextEditingController();
  final TextEditingController batteryIssueDetailController =
      TextEditingController();
  final TextEditingController batteryCycleController = TextEditingController();
  final TextEditingController date_boughtController = TextEditingController();
  final double sizedBoxHight = 16;
  final user = FirebaseAuth.instance.currentUser!;
  String dropdownValue = list.first;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeColors.scaffoldBgColor,
          title: Text(
            "Fly a Drone",
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
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Lets start a Flight",
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                      fontSize: FontSize.xxLarge,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(
                      "But first fill the details below",
                      style: GoogleFonts.poppins(
                        color: ThemeColors.greyTextColor,
                        fontSize: FontSize.medium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  children: [
                    Text(
                      'Pick the Drone/s',
                      style: GoogleFonts.poppins(
                        color: ThemeColors.whiteTextColor,
                        fontSize: FontSize.medium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                        height: 30,
                        width: 30,
                        child: FittedBox(
                            child: FloatingActionButton.small(
                          onPressed: () {
                            pickDroneDialog();
                          },
                          child: Icon(FontAwesomeIcons.plus),
                        )))
                  ],
                ),
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
                              text: 'Pilot\'s Full Name:   ',
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
                            list.map<DropdownMenuItem<String>>((String value) {
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
                SizedBox(height: 200),
                Center(
                  child: SizedBox(
                    height: 160,
                    width: 160,
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: () {},
                        child: Text(
                          'Start Flight',
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
        ));
  }

  void dropdownCallback(String? selectedvalue) {
    if (selectedvalue is String) {
      setState(() {
        dropdownValue = selectedvalue;
      });
    }
  }

  Future pickDroneDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          Color tileColor = Colors.grey;
          return AlertDialog(
            backgroundColor: ThemeColors.scaffoldBgColor,
            scrollable: true,
            title: Text(
              "Add Drones to the flight",
              style: GoogleFonts.poppins(
                color: ThemeColors.whiteTextColor,
                fontSize: FontSize.large,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: StatefulBuilder(
              builder: ((context, setState) {
                return Container(
                  height: 500,
                  width: 300,
                  child: StreamBuilder<List<Drone>>(
                    stream: fetchGroupDrones(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        final drones = snapshot.data!;
                        return Container(
                          child: ListView.builder(
                            itemCount: drones.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return BuildDroneTile(drone: drones[index]);
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return SingleChildScrollView(
                          child: Text('Something went wrong! \n\n${snapshot}',
                              style: TextStyle(color: Colors.white)),
                        );
                      } else {
                        return Container(
                            child: Center(child: CircularProgressIndicator()));
                      }
                    }),
                  ),
                );
              }),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    ;
                  },
                  child: Text('Done')),
            ],
          );
        });
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
