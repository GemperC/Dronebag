// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/app.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:dronebag/domain/flight_data_repository/fight_data_repository.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/domain/user_repository/src/models/models.dart';
import 'package:dronebag/pages/third_layer/fly_drone/fly_drone.dart';
import 'package:dronebag/widgets/main_button_2.dart';
import 'package:google_fonts/google_fonts.dart';

class FlightSummery extends StatefulWidget {
  final Group group;
  final List<Drone> droneList;
  final UserData pilot;
  final String flightPurpose;
  final int flightDuration;
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
  final TextEditingController flight_timeMinutesController =
      TextEditingController();
  final TextEditingController flight_timeHoursController =
      TextEditingController();
  final double sizedBoxHight = 16;
  final user = FirebaseAuth.instance.currentUser!;
  String notificationMsg = 'Waiting for notifications';

  TextEditingController flight_timeController = TextEditingController();
  final TextEditingController hours_till_maintenaceController =
      TextEditingController();
  final TextEditingController maintenanceController = TextEditingController();
  List<double> _currentSliderValues = [];

  @override
  void initState() {
    // print(widget.droneList);
    flight_timeController =
        TextEditingController(text: widget.flightDuration.toString());
    widget.droneList.forEach((drone) {
      if (widget.flightDuration > 0) {
        _currentSliderValues
            .add(widget.flightDuration / widget.droneList.length);
      } else {
        _currentSliderValues.add(0);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_currentSliderValues);
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
                  const SizedBox(height: 16),
                  Text(
                    textAlign: TextAlign.center,
                    'Your total ${widget.flightPurpose} time was ${widget.flightDuration ~/ 60} hours and ${widget.flightDuration % 60} minutes',
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                      fontSize: FontSize.medium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Click a drone to set the details \n make sure to press 'Update drone' to update the drone's information", //"below are the flight details",
                        style: GoogleFonts.poppins(
                          color: ThemeColors.greyTextColor,
                          fontSize: FontSize.small,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'You were piloting the drones:',
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
                      return buildDroneTile(widget.droneList[index], index);
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
                  const SizedBox(height: 100),
                  Center(
                    child: MainButton2(
                      onPressed: () {
                        widget.droneList.forEach((drone) async {
                          final docFlightRecord = FirebaseFirestore.instance
                              .collection('groups')
                              .doc(widget.group.id)
                              .collection('drones')
                              .doc(drone.id)
                              .collection('flight_data')
                              .doc();
                          final flightRecord = FlightData(
                              id: docFlightRecord.id,
                              droneName: drone.name,
                              droneSerial: drone.serial_number,
                              flight_purpose: widget.flightPurpose,
                              flight_time: widget.flightDuration,
                              date: DateTime.now(),
                              pilot: widget.pilot.fullName);

                          final json = flightRecord.toJson();
                          await docFlightRecord.set(json);

                          int droneFlightTime = widget.flightDuration ~/
                              (widget.droneList.length);
                          int newFlightTime =
                              droneFlightTime + drone.flight_time;

                          int newMinutes_till_maintenace =
                              drone.minutes_till_maintenace - droneFlightTime;

                          FirebaseFirestore.instance
                              .collection('groups')
                              .doc(widget.group.id)
                              .collection('drones')
                              .doc(drone.id)
                              .update({
                            "flight_time": newFlightTime,
                            "minutes_till_maintenace":
                                newMinutes_till_maintenace
                          });
                        });
                        Utils.showSnackBarWithColor(
                            'New flight record have been added to the drones',
                            Colors.blue);

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

  Widget buildDroneTile(Drone drone, int index) {
    return ListTile(
        // go to the drone page
        // onTap: () {
        //   editDroneDialog(drone);
        // },
        // build the tile info and design
        title: Center(
      child: Padding(
        // padding betwwent he cards
        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
        child: Container(
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 65, 61, 82),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Padding(
            // padding of the text in the cards
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            child: Column(
              children: [
                Align(
                  //alingemt of the titel
                  alignment: Alignment.center,
                  child: Text(
                    '${drone.name}  |  Serial: ${drone.serial_number}',
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                      fontSize: FontSize.xMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Center(
                  child: Slider(
                    max: 100,
                    value: _currentSliderValues[index],
                    onChanged: (double value) {
                      _currentSliderValues[index] = value;
                      setState(() {
                        _currentSliderValues[index] = value;
                      });
                    },
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
          '${drone.name}  |  Serial: ${drone.serial_number}',
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
                  Center(
                    child: Text(
                      "${widget.flightPurpose} flight time:",
                      style: GoogleFonts.poppins(
                        color: ThemeColors.whiteTextColor,
                        fontSize: FontSize.medium,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 65,
                        width: 80,
                        child: TextFormField(
                          controller: flight_timeHoursController
                            ..text = (widget.flightDuration ~/ 60).toString(),
                          validator: (value) {
                            if (flight_timeHoursController.text.isEmpty) {
                              return "This field can't be empty";
                            }
                            return null;
                          },
                          style: GoogleFonts.poppins(
                            color: ThemeColors.whiteTextColor,
                          ),
                          keyboardType: TextInputType.number,
                          cursorColor: ThemeColors.primaryColor,
                          decoration: InputDecoration(
                            fillColor: ThemeColors.textFieldBgColor,
                            filled: true,
                            labelText: "Hours",
                            labelStyle: GoogleFonts.poppins(
                              color: ThemeColors.textFieldHintColor,
                              fontSize: FontSize.small,
                              fontWeight: FontWeight.w400,
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 65,
                        width: 80,
                        child: TextFormField(
                          controller: flight_timeMinutesController
                            ..text = (widget.flightDuration % 60).toString(),
                          validator: (value) {
                            if (flight_timeMinutesController.text.isEmpty) {
                              return "This field can't be empty";
                            }
                            if (int.parse(flight_timeMinutesController.text) >=
                                    60 ||
                                int.parse(flight_timeMinutesController.text) <=
                                    0) {
                              return "1-59";
                            }
                            return null;
                          },
                          style: GoogleFonts.poppins(
                            color: ThemeColors.whiteTextColor,
                          ),
                          keyboardType: TextInputType.number,
                          cursorColor: ThemeColors.primaryColor,
                          decoration: InputDecoration(
                            fillColor: ThemeColors.textFieldBgColor,
                            filled: true,
                            labelText: "Minutes",
                            labelStyle: GoogleFonts.poppins(
                              color: ThemeColors.textFieldHintColor,
                              fontSize: FontSize.small,
                              fontWeight: FontWeight.w400,
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "This will be added to the drone's flight time", //"below are the flight details",
                    style: GoogleFonts.poppins(
                      color: ThemeColors.greyTextColor,
                      fontSize: FontSize.medium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                int totalFlightTime =
                    int.parse(flight_timeHoursController.text) * 60 +
                        int.parse(flight_timeMinutesController.text);
                int newFlightTime = totalFlightTime + drone.flight_time;

                int newMinutes_till_maintenace =
                    drone.minutes_till_maintenace - totalFlightTime;

                FirebaseFirestore.instance
                    .collection('groups')
                    .doc(widget.group.id)
                    .collection('drones')
                    .doc(drone.id)
                    .update({
                  "flight_time": newFlightTime,
                  "minutes_till_maintenace": newMinutes_till_maintenace
                });

                Navigator.pop(context);
              },
              child: const Text('Update Drone')),
        ],
      ),
    );
  }
}
