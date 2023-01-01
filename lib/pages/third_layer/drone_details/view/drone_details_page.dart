// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/app.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../widgets/widgest.dart';

class DroneDetails extends StatefulWidget {
  final String groupID;
  final Drone drone;
  const DroneDetails({
    Key? key,
    required this.groupID,
    required this.drone,
  }) : super(key: key);

  @override
  State<DroneDetails> createState() => _DroneDetailsState();
}

class _DroneDetailsState extends State<DroneDetails> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController serial_numberController = TextEditingController();
  final TextEditingController flight_timeController = TextEditingController();
  final TextEditingController hours_till_maintenaceController =
      TextEditingController();
  final TextEditingController maintenanceController = TextEditingController();
  final TextEditingController date_boughtController = TextEditingController();
  final double sizedBoxHight = 16;
  int initialIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeColors.scaffoldBgColor,
          title: Text(
            "Drone Details",
            style: GoogleFonts.poppins(
              color: ThemeColors.whiteTextColor,
              fontSize: FontSize.xxLarge,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Edit Drone \nDetails',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.blue,
                  fontSize: FontSize.medium,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                editDroneDialog();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: StreamBuilder<List<Drone>>(
              stream: fetchDrone(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final drone = snapshot.data!.first;
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          richText_listingDroneDetails('Name', drone.name),
                          const SizedBox(height: 12),
                          richText_listingDroneDetails(
                              'Serial Number', drone.serial_number),
                          const SizedBox(height: 12),
                          richText_listingDroneDetailsDates(
                              'Date Added', drone.date_added),
                          const SizedBox(height: 12),
                          richText_listingDroneDetailsDates(
                              'Date Bought', drone.date_bought),
                          const SizedBox(height: 12),
                          richText_listingDroneDetails(
                              'Flight Time', '${drone.flight_time} hours'),
                          const SizedBox(height: 12),
                          richText_listingDroneDetails('Mainetenance Cycle',
                              'every ${drone.maintenance} hours'),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              richText_listingDroneDetails('Next Maintenance in',
                                  '${drone.hours_till_maintenace} flight hours'),
                              const SizedBox(width: 10),
                              RichText(
                                text: TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      FirebaseFirestore.instance
                                          .collection('groups')
                                          .doc(widget.groupID)
                                          .collection('drones')
                                          .doc(drone.id)
                                          .update({
                                        'hours_till_maintenace': drone.maintenance
                                      });
                                    },
                                  text: 'Reset',
                                  style: GoogleFonts.poppins(
                                    color: ThemeColors.primaryColor,
                                    fontSize: FontSize.medium,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 25),
                          Align(
                            alignment: Alignment.center,
                            child: ToggleSwitch(
                              initialLabelIndex: initialIndex,
                              totalSwitches: 3,
                              activeBgColor: const [Colors.blue],
                              activeFgColor: Colors.white,
                              inactiveBgColor: ThemeColors.dialogBoxColor,
                              inactiveFgColor: Colors.white,
                              minWidth: 200,
                              minHeight: 45,
                              customTextStyles: [
                                GoogleFonts.poppins(
                                  color: ThemeColors.whiteTextColor,
                                  fontSize: FontSize.medium,
                                  fontWeight: FontWeight.w500,
                                ),
                                GoogleFonts.poppins(
                                  color: ThemeColors.whiteTextColor,
                                  fontSize: FontSize.medium,
                                  fontWeight: FontWeight.w500,
                                ),
                                GoogleFonts.poppins(
                                  color: ThemeColors.whiteTextColor,
                                  fontSize: FontSize.medium,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                              labels: const [
                                'Maintnance\nRecords',
                                'Issues',
                                'Flight\nRecords'
                              ],
                              onToggle: (index) {
                                setState(() {
                                  initialIndex = index!;
                                });
                              },
                            ),
                          ),
                          SwitchCaseStateManager(index: initialIndex, drone: drone, groupID: widget.groupID,),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SingleChildScrollView(
                    child: Text('Something went wrong! \n\n$snapshot',
                        style: const TextStyle(color: Colors.white)),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ));
  }


  Stream<List<Drone>> fetchDrone() {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupID)
        .collection('drones')
        .where('id', isEqualTo: widget.drone.id)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Drone.fromJson(doc.data())).toList());
  }

  Widget richText_listingDroneDetails(String field, dynamic droneDetail) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: "$field:    ",
            style: GoogleFonts.poppins(
              color: ThemeColors.whiteTextColor,
              fontSize: FontSize.medium,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: '$droneDetail',
            style: GoogleFonts.poppins(
              color: ThemeColors.whiteTextColor,
              fontSize: FontSize.medium,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget richText_listingDroneDetailsDates(
      String field, DateTime droneDetailDate) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: "$field:    ",
            style: GoogleFonts.poppins(
              color: ThemeColors.whiteTextColor,
              fontSize: FontSize.xMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text:
                '${droneDetailDate.day}-${droneDetailDate.month}-${droneDetailDate.year}',
            style: GoogleFonts.poppins(
              color: ThemeColors.whiteTextColor,
              fontSize: FontSize.xMedium,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Future editDroneDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColors.scaffoldBgColor,
        scrollable: true,
        title: Center(
          child: Text(
            "Edit Drone",
            style: GoogleFonts.poppins(
              color: ThemeColors.whiteTextColor,
              fontSize: FontSize.large,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        content: Container(
          width: 300,
          child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameController..text = widget.drone.name,
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
                        color: ThemeColors.textFieldHintColor,
                        fontSize: FontSize.medium,
                        fontWeight: FontWeight.w500,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                    ),
                  ),
                  SizedBox(height: sizedBoxHight),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        child: TextFormField(
                          controller: serial_numberController
                            ..text = widget.drone.serial_number,
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
                              color: ThemeColors.textFieldHintColor,
                              fontSize: FontSize.medium,
                              fontWeight: FontWeight.w500,
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
                      Container(
                        width: 120,
                        child: TextFormField(
                          controller: flight_timeController
                            ..text = widget.drone.flight_time.toString(),
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
                            labelText: "Flight Time",
                            labelStyle: GoogleFonts.poppins(
                              color: ThemeColors.textFieldHintColor,
                              fontSize: FontSize.medium,
                              fontWeight: FontWeight.w500,
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
                  const SizedBox(width: 10),
                  Container(
                    width: 200,
                    child: TextFormField(
                      controller: maintenanceController
                        ..text = widget.drone.maintenance.toString(),
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
                          color: ThemeColors.textFieldHintColor,
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.w500,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
        actions: [
          TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('groups')
                    .doc(widget.groupID)
                    .collection('drones')
                    .doc(widget.drone.id)
                    .delete();
                int count = 0;
                Navigator.popUntil(context, (route) {
                  return count++ == 2;
                });
                Utils.showSnackBarWithColor(
                    'Drone ${widget.drone.name} has been deleted from the group',
                    Colors.blue);
              },
              child: const Text(
                'Delete Drone',
                style: TextStyle(color: Colors.red),
              )),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('groups')
                  .doc(widget.groupID)
                  .collection('drones')
                  .doc(widget.drone.id)
                  .update({
                'name': nameController.text,
                'serial_number': serial_numberController.text,
                'maintenance': int.parse(maintenanceController.text),
                'flight_time': int.parse(flight_timeController.text),
              });
              Navigator.pop(context);
            },
            child: const Text('Update Drone'),
          ),
        ],
      ),
    );
  }
}
