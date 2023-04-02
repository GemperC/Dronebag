import 'package:dronebag/domain/battery_issue_repository/battery_issue_repository.dart';
import 'package:dronebag/domain/battery_repository/battery_repository.dart';
import 'package:dronebag/domain/battery_station_repository/battery_station_repository.dart';
import 'package:dronebag/pages/third_layer/battery_case_details/widgets/widgest.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';

class BatteryDetailDialog extends StatefulWidget {
  final String groupID;
  final BatteryStation batteryStation;
  final Battery battery;
  final String privileges;

  const BatteryDetailDialog({
    Key? key,
    required this.groupID,
    required this.batteryStation,
    required this.battery,
    required this.privileges,
  }) : super(key: key);

  @override
  State<BatteryDetailDialog> createState() => _BatteryDetailDialogState();
}

class _BatteryDetailDialogState extends State<BatteryDetailDialog> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController batteryIssueDetailController;
  final TextEditingController batteryCycleController = TextEditingController();
  final double sizedBoxHight = 16;

  @override
  Widget build(BuildContext context) {
    final fetch = FirestoreFetch(
        groupID: widget.groupID, batteryStation: widget.batteryStation);
    final create = FirestoreCreate(
        groupID: widget.groupID, batteryStation: widget.batteryStation);
    return AlertDialog(
      backgroundColor: ThemeColors.scaffoldBgColor,
      scrollable: true,
      title: Text(
        "Battery ${widget.battery.serial_number}",
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: ThemeColors.whiteTextColor,
          fontSize: FontSize.large,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Column(
        children: [
          Text(
            'Cycle: ',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: FontSize.xMedium,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
              width: 70,
              height: 50,
              child: widget.privileges == "admin"
                  ? TextField(
                      onChanged: (value) {
                        final docBattery = FirebaseFirestore.instance
                            .collection('groups')
                            .doc(widget.groupID)
                            .collection('battery_stations')
                            .doc(widget.batteryStation.id)
                            .collection('batteries')
                            .doc(widget.battery.id);
                        docBattery.update({
                          'cycle': int.parse(value),
                          'last_update': DateTime.now(),
                        });
                      },
                      style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: ThemeColors.textFieldBgColor,
                        filled: true,
                        hintText: "0-200",
                        hintStyle: GoogleFonts.poppins(
                          color: ThemeColors.textFieldHintColor,
                          fontSize: FontSize.small,
                          fontWeight: FontWeight.w400,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(widget.battery.cycle.toString(),
                          style: GoogleFonts.poppins(
                            color: ThemeColors.whiteTextColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w400,
                          )),
                    )),
          const SizedBox(height: 20),
          widget.battery.last_update == null
              ? Container()
              : Text(
                  "Last Update: ${widget.battery.last_update!.day}.${widget.battery.last_update!.month}.${widget.battery.last_update!.year}",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: FontSize.xMedium,
                    fontWeight: FontWeight.w400,
                  ),
                ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.topLeft,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                      fontSize: FontSize.xMedium,
                      fontWeight: FontWeight.w500,
                    ),
                    text: "Issue list ",
                  ),
                  const WidgetSpan(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  )),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        create.createBatteryIssue(widget.battery);
                      },
                    text: 'Add Issue',
                    style: GoogleFonts.poppins(
                      color: ThemeColors.primaryColor,
                      fontSize: FontSize.medium,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ),
          StreamBuilder<List<BatteryIssue>>(
            stream: fetch.fetchBatteryIssue(widget.battery),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                final batteryIssues = snapshot.data!;
                //print(issues.length);
                return SizedBox(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: batteryIssues.length,
                      itemBuilder: (context, index) {
                        batteryIssueDetailController = TextEditingController(
                            text: batteryIssues[index].detail);
                        return BatteryIssueTile(
                            batteryIssueDetailController:
                                batteryIssueDetailController,
                            battery: widget.battery,
                            batteryIssue: batteryIssues[index],
                            batteryStation: widget.batteryStation,
                            groupID: widget.groupID);
                      },
                    ),
                  ]),
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
          ),
          const SizedBox(height: 30)
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Update Battery')),
      ],
    );
  }
}
