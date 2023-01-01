import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:dronebag/domain/flight_data_repository/fight_data_repository.dart';
import 'package:dronebag/domain/issue_repository/issue_repository.dart';
import 'package:dronebag/domain/maintnance_history_repository/maintnance_history_repository.dart';
import 'package:dronebag/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DroneFlightRecords extends StatefulWidget {
  final String groupID;
  final Drone drone;
  const DroneFlightRecords({
    Key? key,
    required this.groupID,
    required this.drone,
  }) : super(key: key);

  @override
  State<DroneFlightRecords> createState() => _DroneFlightRecordsState();
}

class _DroneFlightRecordsState extends State<DroneFlightRecords> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController flightDateController = TextEditingController();
  final TextEditingController flightTimeController = TextEditingController();
  final TextEditingController flightPurposeontroller = TextEditingController();
  final TextEditingController pilotController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      TextButton(
        child: Text(
          'New Record',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.blue,
            fontSize: FontSize.medium,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () {
          // createRecord();
        },
      ),
      // StreamBuilder<List<FlightData>>(
      //     stream: fetchRecords(),
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         final records = snapshot.data!;
      //         return ListView.builder(
      //             physics: const NeverScrollableScrollPhysics(),
      //             shrinkWrap: true,
      //             itemCount: records.length,
      //             itemBuilder: (context, index) {
      //               detailController =
      //                   TextEditingController(text: records[index].detail);
      //               return RecordTile(records[index], detailController);
      //             });
      //       } else if (snapshot.hasError) {
      //         return SingleChildScrollView(
      //           child: Text('Something went wrong! \n\n$snapshot',
      //               style: const TextStyle(color: Colors.white)),
      //         );
      //       } else {
      //         return const Center(child: CircularProgressIndicator());
      //       }
      //     }),
    ]));
  }

  Future createRecord() async {
    final docRecord = FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupID)
        .collection('drones')
        .doc(widget.drone.id)
        .collection('flight_data')
        .doc();
    final record = FlightData(
        comment: commentController.text,
        id: docRecord.id,
        date: DateTime.parse(flightDateController.text),
        flight_time: int.parse(flightTimeController.text),
        flight_purpose: flightPurposeontroller.text,
        pilot: pilotController.text
        );

    final json = record.toJson();
    await docRecord.set(json);
    Utils.showSnackBarWithColor(
        'New issue has been added to the drone', Colors.blue);
  }

  Stream<List<FlightData>> fetchRecords() {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupID)
        .collection('drones')
        .doc(widget.drone.id)
        .collection('flight_data')
        .orderBy("date", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FlightData.fromJson(doc.data()))
            .toList());
  }

  // Widget RecordTile(
  //     FlightData record, TextEditingController detailController) {
  //   String description = record.detail;
  //   Color textDescriptionColor = ThemeColors.whiteTextColor;
  //   if (record.detail == "") {
  //     description = "Click here to add description";
  //     textDescriptionColor = ThemeColors.greyTextColor;
  //   }

  //   return ListTile(
  //     onTap: (() {
  //       showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           backgroundColor: ThemeColors.scaffoldBgColor,
  //           scrollable: true,
  //           title: Center(
  //             child: Text(
  //               "Edit record description",
  //               style: GoogleFonts.poppins(
  //                 color: ThemeColors.whiteTextColor,
  //                 fontSize: FontSize.large,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ),
  //           content: TextFormField(
  //             controller: detailController,
  //             keyboardType: TextInputType.multiline,
  //             maxLines: null,
  //             style: GoogleFonts.poppins(
  //               color: ThemeColors.whiteTextColor,
  //               fontSize: FontSize.medium,
  //               fontWeight: FontWeight.w400,
  //             ),
  //             decoration: InputDecoration(
  //               fillColor: ThemeColors.textFieldBgColor,
  //               filled: true,
  //               hintText: "Record description",
  //               hintStyle: GoogleFonts.poppins(
  //                 color: ThemeColors.textFieldHintColor,
  //                 fontSize: FontSize.small,
  //                 fontWeight: FontWeight.w400,
  //               ),
  //               border: const OutlineInputBorder(
  //                 borderSide: BorderSide.none,
  //                 borderRadius: BorderRadius.all(Radius.circular(18)),
  //               ),
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 child: const Text('Cancel')),
  //             TextButton(
  //                 onPressed: () {
  //                   final docBatteryStationIssue = FirebaseFirestore.instance
  //                       .collection('groups')
  //                       .doc(widget.groupID)
  //                       .collection('drones')
  //                       .doc(widget.drone.id)
  //                       .collection('maintenance_history')
  //                       .doc(record.id);
  //                   docBatteryStationIssue
  //                       .update({'detail': detailController.text});
  //                   Navigator.pop(context);
  //                   Utils.showSnackBarWithColor(
  //                       'Record has been updated', Colors.blue);
  //                 },
  //                 child: const Text(
  //                   'Update Record',
  //                   style: TextStyle(color: Colors.blue),
  //                 )),
  //           ],
  //         ),
  //       );
  //     }),
  //     title: Padding(
  //       padding: const EdgeInsets.all(0),
  //       child: Container(
  //         decoration: const BoxDecoration(
  //             color: Color.fromARGB(255, 32, 32, 32),
  //             borderRadius: BorderRadius.all(Radius.circular(5))),
  //         child: Center(
  //           child: Padding(
  //             padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
  //             child: Column(
  //               children: [
  //                 Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: Text(
  //                     '${record.date.day}-${record.date.month}-${record.date.year}',
  //                     style: GoogleFonts.poppins(
  //                       color: ThemeColors.whiteTextColor,
  //                       fontSize: FontSize.medium,
  //                       fontWeight: FontWeight.w400,
  //                     ),
  //                   ),
  //                 ),
  //                 Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: Text(
  //                     description,
  //                     style: GoogleFonts.poppins(
  //                       color: textDescriptionColor,
  //                       fontSize: FontSize.medium,
  //                       fontWeight: FontWeight.w400,
  //                     ),
  //                   ),
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Align(
  //                       alignment: Alignment.centerRight,
  //                       child: IconButton(
  //                         iconSize: 24,
  //                         splashColor: Colors.transparent,
  //                         color: Colors.red,
  //                         icon: const Icon(Icons.delete),
  //                         onPressed: () {
  //                           showDialog(
  //                             context: context,
  //                             builder: (context) => AlertDialog(
  //                                 backgroundColor: ThemeColors.scaffoldBgColor,
  //                                 title: Center(
  //                                   child: Text(
  //                                     "Delete this record?",
  //                                     style: GoogleFonts.poppins(
  //                                       color: ThemeColors.whiteTextColor,
  //                                       fontSize: FontSize.large,
  //                                       fontWeight: FontWeight.w600,
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 actions: [
  //                                   TextButton(
  //                                       onPressed: () {
  //                                         Navigator.pop(context);
  //                                       },
  //                                       child: const Text(
  //                                         'Cancle',
  //                                         style: TextStyle(color: Colors.blue),
  //                                       )),
  //                                   TextButton(
  //                                       onPressed: () {
  //                                         FirebaseFirestore.instance
  //                                             .collection('groups')
  //                                             .doc(widget.groupID)
  //                                             .collection('drones')
  //                                             .doc(widget.drone.id)
  //                                             .collection("maintenance_history")
  //                                             .doc(record.id)
  //                                             .delete();
  //                                         Navigator.pop(context);
  //                                       },
  //                                       child: const Text(
  //                                         'Yes Delete',
  //                                         style: TextStyle(color: Colors.red),
  //                                       )),
  //                                 ]),
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
