// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/app.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/domain/user_repository/src/models/models.dart';
import 'package:dronebag/pages/third_layer/fly_drone/fly_drone.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/widgets.dart';

class StopFlightPage extends StatefulWidget {
  final Group group;
  final List<Drone> droneList;
  final UserData pilot;
  final String flightPurpose;
  final DateTime airTimeStart;
  const StopFlightPage({
    Key? key,
    required this.group,
    required this.droneList,
    required this.pilot,
    required this.flightPurpose,
    required this.airTimeStart,
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
  late Duration flightDuration;
  String notificationMsg = 'Waiting for notifications';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: ThemeColors.scaffoldBgColor,
            title: Center(
              child: Text(
                "Flight Details",
                style: GoogleFonts.poppins(
                  color: ThemeColors.whiteTextColor,
                  fontSize: FontSize.xxLarge,
                  fontWeight: FontWeight.w600,
                ),
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
                        textAlign: TextAlign.center,
                        "Do not close the app! \nYou can keep the app open in the background", //"below are the flight details",
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'You are piloting the drones:',
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                      fontSize: FontSize.medium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.droneList.length,
                    itemBuilder: ((context, index) {
                      return Center(
                        child: Text(
                          '${widget.droneList[index].name}  |  Serial: ${widget.droneList[index].serial_number}',
                          style: GoogleFonts.poppins(
                            color: ThemeColors.greyTextColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
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
                          text: widget.pilot.fullName,
                          style: GoogleFonts.poppins(
                            color: ThemeColors.greyTextColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Flight\'s Purpose:   ',
                          style: GoogleFonts.poppins(
                            color: ThemeColors.whiteTextColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: widget.flightPurpose,
                          style: GoogleFonts.poppins(
                            color: ThemeColors.greyTextColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 120),
                  Center(
                    child: SizedBox(
                      height: 160,
                      width: 160,
                      child: FittedBox(
                        child: FloatingActionButton(
                          backgroundColor: Colors.red,
                          onPressed: () {
                            flightDuration =
                                DateTime.now().difference(widget.airTimeStart);
                            // List<Drone> tempDroneList = List.from(droneList);
                            // droneList.clear();
                            PostCall notification = PostCall(
                                topic: widget.group.id,
                                purpose: widget.flightPurpose,
                                pilot: widget.pilot.fullName,
                                drones: widget.droneList);
                            notification.makeCallEndFlight();

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FlightSummery(
                                  group: widget.group,
                                  droneList: widget.droneList,
                                  pilot: widget.pilot,
                                  flightPurpose: widget.flightPurpose,
                                  flightDuration: flightDuration.inMinutes,
                                ),
                              ),
                            );
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
    return null;
  }
}
