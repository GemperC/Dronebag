import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/app.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/domain/maintnance_history_repository/maintnance_history_repository.dart';
import 'package:dronebag/domain/user_repository/user_repository.dart';
import 'package:dronebag/pages/third_layer/flights_data/flights_data.dart';
import 'package:dronebag/pages/third_layer/group_members/view/view.dart';
import 'package:dronebag/pages/third_layer/issues/issues.dart';
import 'package:dronebag/pages/third_layer/maintenance_history/maintenance_history.dart';
import 'package:dronebag/widgets/main_button_2.dart';
import 'package:dronebag/widgets/main_button_3.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

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
        body: StreamBuilder<List<Drone>>(
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
                        SizedBox(height: 12),
                        richText_listingDroneDetails(
                            'Serial Number', drone.serial_number),
                        SizedBox(height: 12),
                        richText_listingDroneDetailsDates(
                            'Date Added', drone.date_added),
                        SizedBox(height: 12),
                        richText_listingDroneDetailsDates(
                            'Date Bought', drone.date_bought),
                        SizedBox(height: 12),
                        richText_listingDroneDetails(
                            'Flight Time', '${drone.flight_time} hours'),
                        SizedBox(height: 12),
                        richText_listingDroneDetails('Mainetenance Cycle',
                            'every ${drone.maintenance} hours'),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            richText_listingDroneDetails('Next Maintenance in',
                                '${drone.hours_till_maintenace} flight hours'),
                            SizedBox(width: 10),
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
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MainButton3(
                                text: 'Maintnance History',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MaintenanceRecords(
                                              groupID: widget.groupID,
                                              droneID: drone.id,
                                            )),
                                  );
                                }),
                            SizedBox(width: 20),
                            Text(
                              '10 Records',
                              style: GoogleFonts.poppins(
                                color: ThemeColors.whiteTextColor,
                                fontSize: FontSize.medium,
                                fontWeight: FontWeight.w300,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MainButton3(
                                text: 'Issues',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Issues(
                                              groupID: widget.groupID,
                                              droneID: drone.id,
                                            )),
                                  );
                                }),
                            SizedBox(width: 20),
                            Text(
                              '0 Records',
                              style: GoogleFonts.poppins(
                                color: ThemeColors.whiteTextColor,
                                fontSize: FontSize.medium,
                                fontWeight: FontWeight.w300,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MainButton3(
                                text: 'Flights Data',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FlightDataPage(
                                              groupID: widget.groupID,
                                              droneID: drone.id,
                                            )),
                                  );
                                }),
                            SizedBox(width: 20),
                            Text(
                              '0 Records',
                              style: GoogleFonts.poppins(
                                color: ThemeColors.whiteTextColor,
                                fontSize: FontSize.medium,
                                fontWeight: FontWeight.w300,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return SingleChildScrollView(
                  child: Text('Something went wrong! \n\n${snapshot}',
                      style: TextStyle(color: Colors.white)),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
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
                children: [
                  TextFormField(
                    controller: nameController..text = widget.drone.name,
                    validator: (value) {
                      if (nameController.text.isEmpty)
                        return "This field can't be empty";
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
                        fontSize: FontSize.small,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
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
                            if (nameController.text.isEmpty)
                              return "This field can't be empty";
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
                              fontSize: FontSize.small,
                              fontWeight: FontWeight.w400,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 120,
                        child: TextFormField(
                          controller: flight_timeController
                            ..text = widget.drone.flight_time.toString(),
                          validator: (value) {
                            if (nameController.text.isEmpty)
                              return "This field can't be empty";
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
                              fontSize: FontSize.small,
                              fontWeight: FontWeight.w400,
                            ),
                            border: OutlineInputBorder(
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
                  SizedBox(width: 10),
                  Container(
                    width: 140,
                    child: TextFormField(
                      controller: maintenanceController
                        ..text = widget.drone.maintenance.toString(),
                      validator: (value) {
                        if (nameController.text.isEmpty)
                          return "This field can't be empty";
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
                          fontSize: FontSize.small,
                          fontWeight: FontWeight.w400,
                        ),
                        border: OutlineInputBorder(
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
                Utils.showSnackBarWithColor('Drone ${widget.drone.name} has been deleted from the group', Colors.blue);
              },
              child: Text(
                'Delete Drone',
                style: TextStyle(color: Colors.red),
              )),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel')),
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
            child: Text('Update Drone'),
          ),
        ],
      ),
    );
  }
}
