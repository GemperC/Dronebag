// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../widgets/widgets.dart';

const List<String> list = <String>['Practice', 'Mission'];
List<Drone> droneList = <Drone>[];

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
  late UserData loggedUser;
  late DateTime airTimeStart;
  // late List<Drone> droneList;
  String dropdownValue = list.first;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }

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
                          child: ImageIcon(AssetImage('assets/icons/plus.png')),
                        )))
                  ],
                ),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.topLeft,
                  child: FutureBuilder<UserData?>(
                    future: fetchUser(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final user = snapshot.data!;
                        loggedUser = snapshot.data!;
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
                SizedBox(height: 150),
                Center(
                  child: SizedBox(
                    height: 160,
                    width: 160,
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: () {
                          airTimeStart = DateTime.now();
                          // sendNotificationToAdmins(widget.group.name,
                          //     loggedUser.fullName, droneList);
                          PostCall notification = PostCall(
                              topic: widget.group.id,
                              purpose: dropdownValue,
                              pilot: loggedUser.fullName,
                              drones: droneList,
                              );
                          notification.makeCallStartFlight();

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StopFlightPage(
                                  airTimeStart: airTimeStart,
                                  group: widget.group,
                                  droneList: droneList,
                                  pilot: loggedUser,
                                  flightPurpose: dropdownValue),
                            ),
                          );
                        },
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

  Future sendNotificationToAdmins(
      String topic, String pilot, List<Drone> drones) async {
    http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'content-type': 'application/json',
        'Authorization':
            'key=AAAAksIRG_g:APA91bHSF8IAwnFTcUpYlqvZpGT1vzhfsDR7XeCfQfrSUydQWZqDI7SVzRBuCl90CMp6xp_wOLqZ3x2MblT-SH1RKbACcX3RQFHHYqp0efb2Y8M1zhY0-e6E3e32c2_PVs_QbKIrjqpr'
      },
      body: jsonEncode(
        {
          "to": "/topics/$topic",
          "notification": {
            "title": "$pilot started a flight!",
            "body":
                "In the group $topic \n$pilot is flying the drones:\n${drones.map((e) => e.name)}",
          },
          "priority": "high",
        },
      ),
    );
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
                    Navigator.pop(context);
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

class BuildDroneTile extends StatefulWidget {
  final Drone drone;
  const BuildDroneTile({
    Key? key,
    required this.drone,
  }) : super(key: key);

  @override
  State<BuildDroneTile> createState() => _BuildDroneTileState();
}

class _BuildDroneTileState extends State<BuildDroneTile> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        // go to the drone page
        onTap: () {
          setState(() {
            pressed = !pressed;
            if (pressed) {
              droneList.add(widget.drone);
            } else {
              droneList.remove(widget.drone);
            }
          });
        },
        // build the tile info and design
        title: Center(
          child: Padding(
            // padding betwwent he cards
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Container(
              decoration: BoxDecoration(
                  color:
                      pressed ? Colors.blue : Color.fromARGB(255, 65, 61, 82),

                  // color: Color.fromARGB(255, 65, 61, 82),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Padding(
                // padding of the text in the cards
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    Align(
                      //alingemt of the titel
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.drone.name,
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                          fontSize: FontSize.small,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Align(
                      //alingemt of the titel
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Serial Number: ${widget.drone.serial_number}',
                        style: GoogleFonts.poppins(
                          color: ThemeColors.textFieldHintColor,
                          fontSize: FontSize.small,
                          fontWeight: FontWeight.w400,
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
}
