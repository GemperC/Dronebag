import 'package:dronebag/domain/battery_issue_repository/battery_issue_repository.dart';
import 'package:dronebag/domain/battery_repository/battery_repository.dart';
import 'package:dronebag/domain/battery_station_issue_repository/battery_station_issue_repository.dart';
import 'package:dronebag/domain/battery_station_repository/battery_station_repository.dart';
import 'package:dronebag/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';

class EditBatteryStationDialog extends StatefulWidget {  
  final String groupID;
  final BatteryStation batteryStation;
  const EditBatteryStationDialog({
    Key? key,
    required this.groupID,
    required this.batteryStation,
  }) : super(key: key);

  @override
  State<EditBatteryStationDialog> createState() => _EditBatteryStationDialogState();
}

class _EditBatteryStationDialogState extends State<EditBatteryStationDialog> {
    final formKey = GlobalKey<FormState>();
  final TextEditingController serial_numberController = TextEditingController();
  final TextEditingController batteryIssueDetailController =
      TextEditingController();
  final TextEditingController batteryCycleController = TextEditingController();
  final TextEditingController date_boughtController = TextEditingController();
  final double sizedBoxHight = 16;
  final TextEditingController battery_pairsController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: ThemeColors.scaffoldBgColor,
        scrollable: true,
        title: Center(
          child: Text(
            "Battery Station",
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
                    controller: serial_numberController
                      ..text = widget.batteryStation.serial_number,
                    validator: (value) {
                      if (serial_numberController.text.isEmpty) {
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
                        fontSize: FontSize.small,
                        fontWeight: FontWeight.w400,
                      ),
                      border: const OutlineInputBorder(
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
                FirebaseFirestore.instance
                    .collection('groups')
                    .doc(widget.groupID)
                    .collection('battery_stations')
                    .doc(widget.batteryStation.id)
                    .delete();
                int count = 0;
                Navigator.popUntil(context, (route) {
                  return count++ == 2;
                });
                Utils.showSnackBarWithColor(
                    'Station has been deleted', Colors.blue);
              },
              child: const Text(
                'Delete Station',
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
                  .collection('battery_stations')
                  .doc(widget.batteryStation.id)
                  .update({
                'serial_number': serial_numberController.text,
              });

              final CollectionReference batteryCollection = FirebaseFirestore
                  .instance
                  .collection('groups')
                  .doc(widget.groupID)
                  .collection('battery_stations')
                  .doc(widget.batteryStation.id)
                  .collection("batteries");
              batteryCollection.snapshots().first.then((snapshot) {
                // Loop through each document in the snapshot and update it
                snapshot.docs.forEach((doc) {
                  String serial_number = doc.get("serial_number");
                  String new_Serial_number =
                      "${serial_numberController.text}${serial_number.characters.last}";
                  doc.reference.update({'serial_number': new_Serial_number});
                });
              });

              for (int i = 0; i < 2; i++) {
                Navigator.pop(context);
              }
            },
            child: const Text('Update Station'),
          ),
        ],
      );
  }
}
