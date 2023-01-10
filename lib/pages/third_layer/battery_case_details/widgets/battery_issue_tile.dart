import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/battery_issue_repository/battery_issue_repository.dart';
import 'package:dronebag/domain/battery_repository/battery_repository.dart';
import 'package:dronebag/domain/battery_station_repository/battery_station_repository.dart';
import 'package:dronebag/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const List<String> list = <String>['open', 'closed'];

// ignore: must_be_immutable
class BatteryIssueTile extends StatefulWidget {
  final String groupID;
  final BatteryStation batteryStation;
  final BatteryIssue batteryIssue;
  final Battery battery;
  late TextEditingController batteryIssueDetailController;
  BatteryIssueTile({
    Key? key,
    required this.groupID,
    required this.batteryStation,
    required this.batteryIssue,
    required this.battery,
    required this.batteryIssueDetailController,
  }) : super(key: key);

  @override
  State<BatteryIssueTile> createState() => _BatteryIssueTileState();
}

class _BatteryIssueTileState extends State<BatteryIssueTile> {
  String dropdownValue = "";

  @override
  Widget build(BuildContext context) {
    String issueDescription = widget.batteryIssue.detail;
    Color textDescriptionColor = ThemeColors.whiteTextColor;
    if (widget.batteryIssue.detail == "") {
      issueDescription = "Click here to add description";
      textDescriptionColor = ThemeColors.greyTextColor;
    }

    return ListTile(
      onTap: (() {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: ThemeColors.scaffoldBgColor,
            scrollable: true,
            title: Center(
              child: Text(
                "Edit issue description",
                style: GoogleFonts.poppins(
                  color: ThemeColors.whiteTextColor,
                  fontSize: FontSize.large,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            content: Column(
              children: [
                TextFormField(
                  controller: widget.batteryIssueDetailController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: GoogleFonts.poppins(
                    color: ThemeColors.whiteTextColor,
                    fontSize: FontSize.medium,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    fillColor: ThemeColors.textFieldBgColor,
                    filled: true,
                    hintText: "Issue description",
                    hintStyle: GoogleFonts.poppins(
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
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Text(
                        'Status:   ',
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 80,
                        child: DropdownButtonFormField<String>(
                          elevation: 16,
                          style: GoogleFonts.poppins(
                            color: ThemeColors.greyTextColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w600,
                          ),
                          items: list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: dropdownValue,
                          onChanged: (String? value) {
                            dropdownValue = value!;
                          },

                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    final docBatteryIssue = FirebaseFirestore.instance
                        .collection('groups')
                        .doc(widget.groupID)
                        .collection('battery_stations')
                        .doc(widget.batteryStation.id)
                        .collection('batteries')
                        .doc(widget.battery.id)
                        .collection("battery_issues")
                        .doc(widget.batteryIssue.id);
                    docBatteryIssue.update({
                      'detail': widget.batteryIssueDetailController.text,
                      'status': dropdownValue
                    });
                    Navigator.pop(context);
                    Utils.showSnackBarWithColor(
                        'Issue has been updated', Colors.blue);
                  },
                  child: const Text(
                    'Update issue',
                    style: TextStyle(color: Colors.blue),
                  )),
            ],
          ),
        );
      }),
      title: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 32, 32, 32),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${widget.batteryIssue.date.day}-${widget.batteryIssue.date.month}-${widget.batteryIssue.date.year}',
                      style: GoogleFonts.poppins(
                        color: ThemeColors.whiteTextColor,
                        fontSize: FontSize.medium,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      issueDescription,
                      style: GoogleFonts.poppins(
                        color: textDescriptionColor,
                        fontSize: FontSize.medium,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Status:  ${widget.batteryIssue.status}',
                          style: GoogleFonts.poppins(
                            color: ThemeColors.whiteTextColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          iconSize: 24,
                          splashColor: Colors.transparent,
                          color: Colors.white,
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  backgroundColor: ThemeColors.scaffoldBgColor,
                                  title: Center(
                                    child: Text(
                                      "Delete this issue?",
                                      style: GoogleFonts.poppins(
                                        color: ThemeColors.whiteTextColor,
                                        fontSize: FontSize.large,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Cancle',
                                          style: TextStyle(color: Colors.blue),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('groups')
                                              .doc(widget.groupID)
                                              .collection('battery_stations')
                                              .doc(widget.batteryStation.id)
                                              .collection("batteries")
                                              .doc(widget.battery.id)
                                              .collection("battery_issues")
                                              .doc(widget.batteryIssue.id)
                                              .delete();
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Yes Delete',
                                          style: TextStyle(color: Colors.red),
                                        )),
                                  ]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
