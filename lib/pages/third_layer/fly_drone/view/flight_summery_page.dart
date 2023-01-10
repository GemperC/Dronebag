// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace, avoid_function_literals_in_foreach_calls, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/app.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:dronebag/domain/flight_data_repository/fight_data_repository.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/domain/user_repository/src/models/models.dart';
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
  double totalSlidervalue = 0;

  @override
  void initState() {
    // print(widget.droneList);
    flight_timeController =
        TextEditingController(text: widget.flightDuration.toString());
    widget.droneList.forEach((drone) {
      if ((widget.flightDuration / widget.droneList.length) > 1) {
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
              padding: const EdgeInsets.all(20),
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
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 17),
                      child: Text(
                        textAlign: TextAlign.center,
                        "On defualt each drone gets 1/3 of the total flight time \n but you can change it with the sliders \n click the Done button below to confirm", //"below are the flight details",
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 129, 123, 123),
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
                    physics: const NeverScrollableScrollPhysics(),
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
                        int index = 0;
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
                              flight_time: _currentSliderValues[index].toInt(),
                              date: DateTime.now(),
                              pilot: widget.pilot.fullName);

                          final json = flightRecord.toJson();
                          await docFlightRecord.set(json);

                          int droneFlightTime = _currentSliderValues[index].toInt();
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
                          index++;
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
                Align(
                  //alingemt of the titel
                  alignment: Alignment.center,
                  child: Text(
                    '${_currentSliderValues[index].toInt() ~/ 60} hours and ${_currentSliderValues[index].toInt() % 60} minutes',
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                      fontSize: FontSize.xMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                widget.flightDuration != 0
                    ? Center(
                        child: Slider(
                          max: widget.flightDuration.toDouble(),
                          value: _currentSliderValues[index],
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValues[index] =
                                  value.round().toDouble();
                            });
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
