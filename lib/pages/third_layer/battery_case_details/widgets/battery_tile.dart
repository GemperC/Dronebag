// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:dronebag/domain/battery_issue_repository/battery_issue_repository.dart';
import 'package:dronebag/domain/battery_repository/battery_repository.dart';
import 'package:dronebag/domain/battery_station_repository/battery_station_repository.dart';
import 'package:dronebag/pages/third_layer/battery_case_details/widgets/battery_detail_dialog.dart';
import 'package:dronebag/pages/third_layer/battery_case_details/widgets/fetches.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dronebag/config/font_size.dart';

class BatteryTile extends StatefulWidget {
  final String groupID;
  final BatteryStation batteryStation;
  final Battery battery;
  const BatteryTile({
    Key? key,
    required this.groupID,
    required this.batteryStation,
    required this.battery,
  }) : super(key: key);

  @override
  State<BatteryTile> createState() => _BatteryTileState();
}

class _BatteryTileState extends State<BatteryTile> {
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
    final fetch = FirestoreFetch(
        groupID: widget.groupID, batteryStation: widget.batteryStation);
    Color batteryColor = Colors.green;
    if (widget.battery.cycle >= 50 && widget.battery.cycle < 100) {
      batteryColor =  Color.fromARGB(255, 0, 84, 3);
    } else if (widget.battery.cycle >= 100 && widget.battery.cycle < 150) {
      batteryColor = Colors.orange;
    } else if (widget.battery.cycle >= 150) {
      batteryColor = Colors.red;
    }
    return StreamBuilder<List<BatteryIssue>>(
        stream: fetch.fetchBatteryIssue(widget.battery),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final batteryIssues = snapshot.data!;

            return ListTile(
              // go to the battery case page

              // build the tile info and design
              title: Center(
                child: Padding(
                  // padding betwwent he cards
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    // height: 120,
                    width: 150,
                    decoration: BoxDecoration(
                        color: batteryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(11))),
                    child: Column(
                      children: [
                        Text(
                          widget.battery.serial_number,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "Cycle: ${widget.battery.cycle}",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          batteryIssues.isEmpty
                              ? ""
                              : "Issues: ${batteryIssues.length.toString()}",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => BatteryDetailDialog(
                        battery: widget.battery,
                        batteryStation: widget.batteryStation,
                        groupID: widget.groupID));
              },
            );
          } else if (snapshot.hasError) {
            return SingleChildScrollView(
              child: Text('Something went wrong! \n\n$snapshot',
                  style: const TextStyle(color: Colors.white)),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
