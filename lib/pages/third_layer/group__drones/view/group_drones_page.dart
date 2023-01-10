// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, sized_box_for_whitespace, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/app.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/pages/third_layer/drone_details/view/view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class GroupDrones extends StatefulWidget {
  final Group group;
  final String privileges;
  const GroupDrones({
    Key? key,
    required this.group,
    required this.privileges,
  }) : super(key: key);

  @override
  State<GroupDrones> createState() => _GroupDronesState();
}

class _GroupDronesState extends State<GroupDrones> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController flightsController = TextEditingController();
  final TextEditingController serial_numberController = TextEditingController();
  final TextEditingController flight_timeHoursController =
      TextEditingController();
  final TextEditingController flight_timeMinutesController =
      TextEditingController();

  final TextEditingController maintenanceController = TextEditingController();
  final TextEditingController date_boughtController = TextEditingController();
  final double sizedBoxHight = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.scaffoldBgColor,
        title: Text(
          "Drone List",
          style: GoogleFonts.poppins(
            color: ThemeColors.whiteTextColor,
            fontSize: FontSize.xxLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'Add New\nDrone',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.blue,
                fontSize: FontSize.medium,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              if (widget.privileges == 'admin') {
              addDroneDialog();
               } else {
                Utils.showSnackBarWithColor(
                    'You dont have to required priviledges', Colors.red);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(30),
            child: StreamBuilder<List<Drone>>(
              stream: fetchGroupDrones(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final drones = snapshot.data!;
                  return ListView(
                      children: drones.map(buildDroneTile).toList());
                } else if (snapshot.hasError) {
                  return SingleChildScrollView(
                    child: Text('Something went wrong! \n\n$snapshot',
                        style: const TextStyle(color: Colors.white)),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
            )),
      ),
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

//build the tile of the drone
  Widget buildDroneTile(Drone drone) {
    Color maintenanceTextColor = ThemeColors.textFieldlabelColor;
    if (drone.minutes_till_maintenace <= 60) {
      maintenanceTextColor = Colors.red;
    }

    return ListTile(
        // go to the drone page
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DroneDetails(
                      groupID: widget.group.id,
                      drone: drone,
                      privileges: widget.privileges
                    )),
          );
        },
        // build the tile info and design
        title: Center(
          child: Padding(
            // padding betwwent he cards
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 65, 61, 82),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Padding(
                // padding of the text in the cards
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: Column(
                  children: [
                    Align(
                      //alingemt of the titel
                      alignment: Alignment.topLeft,
                      child: Text(
                        drone.name,
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                          fontSize: FontSize.xxLarge,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Align(
                      //alingemt of the titel
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Maintenance in ~${drone.minutes_till_maintenace ~/ 60} hours',
                        style: GoogleFonts.poppins(
                          color: maintenanceTextColor,
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Align(
                      //alingemt of the titel
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Airtime: ~${drone.flight_time ~/ 60} hours',
                        style: GoogleFonts.poppins(
                          color: ThemeColors.textFieldlabelColor,
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    FutureBuilder<int>(
                      future: FirebaseFirestore.instance
                          .collection(
                              'groups/${widget.group.id}/drones/${drone.id}/issues')
                          .where("status", isEqualTo: "open")
                          .get()
                          .then((value) => value.docs.length),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data! != 0) {
                          int openIssueNum = snapshot.data!;
                          return Align(
                            //alingemt of the titel
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Open Issues: $openIssueNum',
                              style: GoogleFonts.poppins(
                                color: Colors.red[400],
                                fontSize: FontSize.medium,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          Container();
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

// dialog to add new drones to the group
  Future addDroneDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColors.scaffoldBgColor,
        scrollable: true,
        title: Text(
          "Add New Drone",
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
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (nameController.text.isEmpty) {
                        return "This field can't be empty";
                      }
                      return null;
                    },
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                    ),
                    keyboardType: TextInputType.name,
                    cursorColor: ThemeColors.primaryColor,
                    decoration: InputDecoration(
                      fillColor: ThemeColors.textFieldBgColor,
                      filled: true,
                      labelText: "Drone Name",
                      labelStyle: GoogleFonts.poppins(
                        color: ThemeColors.textFieldlabelColor,
                        fontSize: FontSize.small,
                        fontWeight: FontWeight.w400,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                    ),
                  ),
                  SizedBox(height: sizedBoxHight),
                  TextFormField(
                    controller: serial_numberController,
                    validator: (value) {
                      if (nameController.text.isEmpty) {
                        return "This field can't be empty";
                      }
                      return null;
                    },
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                    ),
                    keyboardType: TextInputType.name,
                    cursorColor: ThemeColors.primaryColor,
                    decoration: InputDecoration(
                      fillColor: ThemeColors.textFieldBgColor,
                      filled: true,
                      labelText: "Serial number",
                      labelStyle: GoogleFonts.poppins(
                        color: ThemeColors.textFieldlabelColor,
                        fontSize: FontSize.small,
                        fontWeight: FontWeight.w400,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                    ),
                  ),
                  SizedBox(height: sizedBoxHight),
                  Text(
                    "Flight Time:",
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                      fontSize: FontSize.medium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 65,
                        width: 80,
                        child: TextFormField(
                          controller: flight_timeHoursController,
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
                              color: ThemeColors.textFieldlabelColor,
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
                          controller: flight_timeMinutesController,
                          validator: (value) {
                            if (flight_timeMinutesController.text.isEmpty) {
                              return "This field can't be empty";
                            }
                            if (int.parse(flight_timeMinutesController.text) >=
                                    60 ||
                                int.parse(flight_timeMinutesController.text) <
                                    0) {
                              return "0-59";
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
                              color: ThemeColors.textFieldlabelColor,
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
                  SizedBox(height: sizedBoxHight),
                  TextFormField(
                    controller: flightsController,
                    validator: (value) {
                      if (flightsController.text.isEmpty) {
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
                      labelText: "Flights",
                      labelStyle: GoogleFonts.poppins(
                        color: ThemeColors.textFieldlabelColor,
                        fontSize: FontSize.small,
                        fontWeight: FontWeight.w400,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                    ),
                  ),
                  SizedBox(height: sizedBoxHight),
                  TextFormField(
                    controller: maintenanceController,
                    validator: (value) {
                      if (nameController.text.isEmpty) {
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
                      labelText: "Maintnenace cycle in hours",
                      labelStyle: GoogleFonts.poppins(
                        color: ThemeColors.textFieldlabelColor,
                        fontSize: FontSize.small,
                        fontWeight: FontWeight.w400,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                    ),
                  ),
                  SizedBox(height: sizedBoxHight),
                  DateTimeField(
                    format: DateFormat('yyyy-MM-dd'),
                    controller: date_boughtController,
                    onShowPicker: ((context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                    }),
                    validator: (value) {
                      if (date_boughtController.text.isEmpty) {
                        date_boughtController.text = 'unknown';
                      }
                      return null;
                    },
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                    ),
                    keyboardType: TextInputType.datetime,
                    cursorColor: ThemeColors.primaryColor,
                    decoration: InputDecoration(
                      fillColor: ThemeColors.textFieldBgColor,
                      filled: true,
                      labelText: "Date bought",
                      labelStyle: GoogleFonts.poppins(
                        color: ThemeColors.textFieldlabelColor,
                        fontSize: FontSize.small,
                        fontWeight: FontWeight.w400,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                    ),
                  ),
                  Text(
                    "Leave blank if date is unknown",
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
                createDrone();
              },
              child: const Text('Add Drone')),
        ],
      ),
    );
  }

//create a new drone and add it to the group
  Future createDrone() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      final docDrone = FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.group.id)
          .collection('drones')
          .doc();
      final drone = Drone(
          name: nameController.text.trim(),
          serial_number: serial_numberController.text,
          flight_time: int.parse(flight_timeHoursController.text) * 60 +
              int.parse(flight_timeMinutesController.text),
          id: docDrone.id,
          minutes_till_maintenace: minutesLeftToMaintenance(),
          maintenance: int.parse(maintenanceController.text) * 60,
          date_added: DateTime.now(),
          current_location: "",
          date_bought: date_boughtController.text == "unknown"
              ? DateTime.parse("1999-02-10")
              : DateTime.parse(date_boughtController.text),
          flights: int.parse(flightsController.text));

      final json = drone.toJson();
      await docDrone.set(json);
      Utils.showSnackBarWithColor(
          'Drone has been added to the group', Colors.blue);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DroneDetails(
                  groupID: widget.group.id,
                  drone: drone,
                  privileges: widget.privileges,
                )),
      );
    }
  }

//find how many hours left till drone maintnance
  int minutesLeftToMaintenance() {
    int flightTime = int.parse(flight_timeHoursController.text) * 60 +
        int.parse(flight_timeMinutesController.text);
    int maintnanceCycle = int.parse(maintenanceController.text) * 60;
    return maintnanceCycle - (flightTime % maintnanceCycle);
  }
}
