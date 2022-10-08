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
        body: buildDronePage(widget.drone));
  }

  Widget buildDronePage(Drone drone) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            richText_listingDroneDetails('Name', drone.name),
            SizedBox(height: 16),
            richText_listingDroneDetails('Serial Number', drone.serial_number),
            SizedBox(height: 16),
            richText_listingDroneDetailsDates('Date Added', drone.date_added),
            SizedBox(height: 16),
            richText_listingDroneDetailsDates('Date Bought', drone.date_bought),
            SizedBox(height: 16),
            richText_listingDroneDetails(
                'Flight Time', '${drone.flight_time} hours'),
            SizedBox(height: 16),
            richText_listingDroneDetails(
                'Mainetenance Cycle', 'every ${drone.maintenance} hours'),
            SizedBox(height: 16),
            richText_listingDroneDetails('Next Maintenance in',
                '${drone.hours_till_maintenace} flight hours'),
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
                            builder: (context) => MaintenanceRecords(
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
                    fontSize: FontSize.large,
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
                    fontSize: FontSize.large,
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
                    fontSize: FontSize.large,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            ),
            SizedBox(height: 50),
            MainButton2(text: 'Fly This Drone', onPressed: () {})
          ],
        ),
      ),
    );
  }

  Widget richText_listingDroneDetails(String field, dynamic droneDetail) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: "$field:    ",
            style: GoogleFonts.poppins(
              color: ThemeColors.whiteTextColor,
              fontSize: FontSize.large,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: '$droneDetail',
            style: GoogleFonts.poppins(
              color: ThemeColors.whiteTextColor,
              fontSize: FontSize.large,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
        style: GoogleFonts.poppins(
          color: ThemeColors.whiteTextColor,
          fontSize: FontSize.large,
          fontWeight: FontWeight.w600,
        ),
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
              fontSize: FontSize.large,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text:
                '${droneDetailDate.year}-${droneDetailDate.month}-${droneDetailDate.day}',
            style: GoogleFonts.poppins(
              color: ThemeColors.whiteTextColor,
              fontSize: FontSize.large,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
        style: GoogleFonts.poppins(
          color: ThemeColors.whiteTextColor,
          fontSize: FontSize.large,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future editDroneDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColors.scaffoldBgColor,
        scrollable: true,
        title: Text(
          "Edit Drone",
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
                      hintText: "Drone Name",
                      hintStyle: GoogleFonts.poppins(
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
                  TextFormField(
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
                      hintText: "Serial number",
                      hintStyle: GoogleFonts.poppins(
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
                  TextFormField(
                    controller: flight_timeController,
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
                      hintText: "Flight Time",
                      hintStyle: GoogleFonts.poppins(
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
                  TextFormField(
                    controller: maintenanceController,
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
                      hintText: "Maintnenace cycle in hours",
                      hintStyle: GoogleFonts.poppins(
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
                      if (nameController.text.isEmpty)
                        return "This field can't be empty";
                    },
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                    ),
                    keyboardType: TextInputType.datetime,
                    cursorColor: ThemeColors.primaryColor,
                    decoration: InputDecoration(
                      fillColor: ThemeColors.textFieldBgColor,
                      filled: true,
                      hintText: "Date bought",
                      hintStyle: GoogleFonts.poppins(
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
                
              },
              child: Text('Update Drone')),
        ],
      ),
    );
  }
}
