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
            richText_listingDroneDetails('Flight Time', '${drone.flight_time} hours'),
            SizedBox(height: 16),
            richText_listingDroneDetails(
                'Mainetenance Cycle', 'every ${drone.maintenance} hours'),
            SizedBox(height: 16),
            richText_listingDroneDetails('Next Maintenance in', '${drone.hours_till_maintenace} flight hours'),
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
}
