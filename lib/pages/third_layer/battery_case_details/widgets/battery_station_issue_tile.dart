import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/battery_station_issue_repository/battery_station_issue_repository.dart';
import 'package:dronebag/domain/battery_station_repository/battery_station_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BatteryStationIssueTile extends StatefulWidget {
  final String groupID;
  final BatteryStation batteryStation;
  final BatteryStationIssue batteryStationIssue;
  const BatteryStationIssueTile({
    Key? key,
    required this.groupID,
    required this.batteryStation,
    required this.batteryStationIssue,
  }) : super(key: key);

  @override
  State<BatteryStationIssueTile> createState() =>
      _BatteryStationIssueTileState();
}

class _BatteryStationIssueTileState extends State<BatteryStationIssueTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
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
                      '${widget.batteryStationIssue.date.day}-${widget.batteryStationIssue.date.month}-${widget.batteryStationIssue.date.year}',
                      style: GoogleFonts.poppins(
                        color: ThemeColors.whiteTextColor,
                        fontSize: FontSize.medium,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  TextFormField(
                    maxLines: null,
                    onChanged: (value) {
                      final docBatteryStationIssue = FirebaseFirestore.instance
                          .collection('groups')
                          .doc(widget.groupID)
                          .collection('battery_stations')
                          .doc(widget.batteryStation.id)
                          .collection('issues')
                          .doc(widget.batteryStationIssue.id);
                      docBatteryStationIssue.update({'detail': value});
                    },
                    initialValue: widget.batteryStationIssue.detail,
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                      fontSize: FontSize.medium,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Status:  ${widget.batteryStationIssue.status}',
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
                                              .collection("issues")
                                              .doc(widget.batteryStationIssue.id)
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
