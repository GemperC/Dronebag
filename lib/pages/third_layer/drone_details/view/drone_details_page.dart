import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/app.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/domain/user_repository/user_repository.dart';
import 'package:dronebag/pages/third_layer/group_members/view/view.dart';
import 'package:dronebag/widgets/main_button_2.dart';
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
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(30),
            child: buildDronePage(widget.drone)),
      ),
    );
  }

  Widget buildDronePage(Drone drone) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 80,
          width: 450,
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Center(
            child: Text(
              """
name: ${drone.name}
date added: ${drone.date_added.year}.${drone.date_added.month}.${drone.date_added.day}
flight time: ${drone.flight_time}
""",
              style: GoogleFonts.poppins(
                color: ThemeColors.whiteTextColor,
                fontSize: FontSize.medium,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }


}
