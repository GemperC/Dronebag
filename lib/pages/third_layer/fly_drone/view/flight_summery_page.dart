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
import 'package:dronebag/services/local_notifications.dart';
import 'package:dronebag/widgets/main_button_2.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/widgets.dart';

class FlightSummery extends StatefulWidget {
  final Group group;
  final List<Drone> droneList;
  final UserData pilot;
  final String flightPurpose;
  final Duration flightDuration;
  const FlightSummery({
    Key? key,
    required this.group,
    required this.droneList,
    required this.pilot,
    required this.flightPurpose,
    required this.flightDuration,
  }) : super(key: key);

  @override
  State<FlightSummery> createState() => _FlightSummeryState();
}

class _FlightSummeryState extends State<FlightSummery> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController serial_numberController = TextEditingController();
  final TextEditingController batteryIssueDetailController =
      TextEditingController();
  final TextEditingController batteryCycleController = TextEditingController();
  final TextEditingController date_boughtController = TextEditingController();
  final double sizedBoxHight = 16;
  final user = FirebaseAuth.instance.currentUser!;
  String notificationMsg = 'Waiting for notifications';

  TextEditingController flight_timeController = TextEditingController();
  final TextEditingController hours_till_maintenaceController =
      TextEditingController();
  final TextEditingController maintenanceController = TextEditingController();
  @override
  void initState() {
    print(widget.droneList);
    flight_timeController =
        TextEditingController(text: widget.flightDuration.inSeconds.toString());
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
                "Flight Summery",
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
                      "You ended the flight",
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
                        'Click a drone to see the details', //"below are the flight details",
                        style: GoogleFonts.poppins(
                          color: ThemeColors.greyTextColor,
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    'You were piloting the drones:',
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                      fontSize: FontSize.medium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.droneList.length,
                    itemBuilder: ((context, index) {
                      return buildDroneTile(widget.droneList[index]);
                      // return Center(
                      //   child: Text(
                      //     '${widget.droneList[index].name}  |  Serial: ${widget.droneList[index].serial_number}',
                      //     style: GoogleFonts.poppins(
                      //       color: ThemeColors.greyTextColor,
                      //       fontSize: FontSize.medium,
                      //       fontWeight: FontWeight.w600,
                      //     ),
                      //   ),
                      // );
                    }),
                  ),
                  SizedBox(height: 150),
                  Center(
                    child: MainButton2(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: 'Done',
                      textColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget buildDroneTile(Drone drone) {
    return ListTile(
        // go to the drone page
        onTap: () {
          editDroneDialog(drone);
        },
        // build the tile info and design
        title: Center(
          child: Padding(
            // padding betwwent he cards
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 65, 61, 82),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Padding(
                // padding of the text in the cards
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: Column(
                  children: [
                    Align(
                      //alingemt of the titel
                      alignment: Alignment.center,
                      child: Text(
                        drone.name,
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                          fontSize: FontSize.xMedium,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future editDroneDialog(Drone drone) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColors.scaffoldBgColor,
        scrollable: true,
        title: Text(
          "Drone Details",
          style: GoogleFonts.poppins(
            color: ThemeColors.whiteTextColor,
            fontSize: FontSize.large,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Container(
          width: 300,
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    drone.name,
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                    ),
                  ),
                  SizedBox(height: sizedBoxHight),
                  Text(
                    drone.serial_number,
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                    ),
                  ),
                  SizedBox(height: sizedBoxHight),
                  TextFormField(
                    controller: flight_timeController,
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                    ),
                    keyboardType: TextInputType.number,
                    cursorColor: ThemeColors.primaryColor,
                    decoration: InputDecoration(
                      fillColor: ThemeColors.textFieldBgColor,
                      filled: true,
                      labelText: "Drone air time in hours",
                      labelStyle: GoogleFonts.poppins(
                        color: ThemeColors.textFieldHintColor,
                        // fontSize: FontSize.small,
                        // fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                    ),
                  ),
                  // SizedBox(height: sizedBoxHight),
                  // TextFormField(
                  //   controller: maintenanceController,
                  //   style: GoogleFonts.poppins(
                  //     color: ThemeColors.whiteTextColor,
                  //   ),
                  //   keyboardType: TextInputType.number,
                  //   cursorColor: ThemeColors.primaryColor,
                  //   decoration: InputDecoration(
                  //     fillColor: ThemeColors.textFieldBgColor,
                  //     filled: true,
                  //     hintText: "Maintnenace cycle in hours",
                  //     hintStyle: GoogleFonts.poppins(
                  //       color: ThemeColors.textFieldHintColor,
                  //       fontSize: FontSize.small,
                  //       fontWeight: FontWeight.w400,
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderSide: BorderSide.none,
                  //       borderRadius: BorderRadius.all(Radius.circular(18)),
                  //     ),
                  //   ),
                  // ),
                ],
              )),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel')),
          TextButton(
              onPressed: () {
                int totalFlightTime =
                    int.parse(flight_timeController.text) + drone.flight_time;

                int hours_till_maintenaceNEW = drone.hours_till_maintenace- 
                    int.parse(flight_timeController.text);
                    

                FirebaseFirestore.instance
                    .collection('groups')
                    .doc(widget.group.id)
                    .collection('drones')
                    .doc(drone.id)
                    .update({
                      "flight_time": totalFlightTime,
                      "hours_till_maintenace": hours_till_maintenaceNEW});

                Navigator.pop(context);
              },
              child: Text('Update Drone')),
        ],
      ),
    );
  }
}