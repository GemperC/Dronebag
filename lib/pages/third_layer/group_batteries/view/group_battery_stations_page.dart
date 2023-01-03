// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, sized_box_for_whitespace, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/app.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/domain/battery_repository/src/models/models.dart';
import 'package:dronebag/domain/battery_station_repository/src/models/models.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/pages/third_layer/battery_case_details/battery_case_details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class GroupBatteryStations extends StatefulWidget {
  final Group group;
  const GroupBatteryStations({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  State<GroupBatteryStations> createState() => _GroupBatteryStationsState();
}

class _GroupBatteryStationsState extends State<GroupBatteryStations> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController serial_numberController = TextEditingController();
  final TextEditingController battery_pairsController = TextEditingController();
  final TextEditingController date_boughtController = TextEditingController();
  final TextEditingController ownershipController = TextEditingController();
  final double sizedBoxHight = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.scaffoldBgColor,
        title: Text(
          "Battery Stations",
          style: GoogleFonts.poppins(
            color: ThemeColors.whiteTextColor,
            fontSize: FontSize.xxLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'Add New\nStation',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.blue,
                fontSize: FontSize.medium,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              addBatteryStationDialog();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(30),
            child: StreamBuilder<List<BatteryStation>>(
              stream: fetchGroupBatteriesStations(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final batteryStations = snapshot.data!;
                  return ListView(
                      children: batteryStations
                          .map(buildBatteryStationTile)
                          .toList());
                } else if (snapshot.hasError) {
                  return SingleChildScrollView(
                    child: Text('Something went wrong! \n\n$snapshot',
                        style: const TextStyle(color: Colors.white)),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
            )),
      ),
    );
  }

//fetch group's drones list
  Stream<List<BatteryStation>> fetchGroupBatteriesStations() {
    return FirebaseFirestore.instance
        .collection('groups/${widget.group.id}/battery_stations')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BatteryStation.fromJson(doc.data()))
            .toList());
  }

//build the tile of the drone
  Widget buildBatteryStationTile(BatteryStation batteryStation) {
    return ListTile(
        // go to the battery case page
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BatteryStationDetails(
                      groupID: widget.group.id,
                      batteryStation: batteryStation,
                    )),
          );
        },
        // build the tile info and design
        title: Center(
          child: Padding(
            // padding betwwent he cards
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 65, 61, 82),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Padding(
                // padding of the text in the cards
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: Column(
                  children: [
                    Align(
                      //alingemt of the titel
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Battery Station ${batteryStation.serial_number}',
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                          fontSize: FontSize.xxLarge,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Align(
                      //alingemt of the titel
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${batteryStation.battery_pairs} battery pairs',
                        style: GoogleFonts.poppins(
                          color: ThemeColors.textFieldHintColor,
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

// dialog to add new drones to the group
  Future addBatteryStationDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColors.scaffoldBgColor,
        scrollable: true,
        title: Text(
          "Add New Battery Station",
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
                    controller: serial_numberController,
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
                  SizedBox(height: sizedBoxHight),
                  TextFormField(
                    controller: battery_pairsController,
                    validator: (value) {
                      if (battery_pairsController.text.isEmpty) {
                        return "This field can't be empty";
                      }
                      return null;
                    },
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                    ),
                    keyboardType: TextInputType.number,
                    cursorColor: ThemeColors.primaryColor,
                    decoration: InputDecoration(
                      fillColor: ThemeColors.textFieldBgColor,
                      filled: true,
                      hintText: "Battery pairs",
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
                  SizedBox(height: sizedBoxHight),
                  TextFormField(
                    controller: ownershipController,
                    validator: (value) {
                      if (ownershipController.text.isEmpty) {
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
                      hintText: "Ownership",
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
                      if (date_boughtController.text.isEmpty) {
                        date_boughtController.text = 'unknown';
                      }
                      return null;
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
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Leave blank if date is unknown",
                    style: GoogleFonts.poppins(
                      color: ThemeColors.greyTextColor,
                      fontSize: FontSize.medium,
                      fontWeight: FontWeight.w500,
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
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                createBatteryStation();
                Navigator.pop(context);
              },
              child: const Text('Add Battery stations')),
        ],
      ),
    );
  }

//create a new drone and add it to the group
  Future createBatteryStation() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      //create battery station
      final docBatteryStation = FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.group.id)
          .collection('battery_stations')
          .doc();
      final batteryStation = BatteryStation(
        serial_number: serial_numberController.text,
        id: docBatteryStation.id,
        ownership: ownershipController.text,
        battery_pairs: int.parse(battery_pairsController.text),
        date_bought: date_boughtController.text=="unknown" ? DateTime.parse("1999-02-10") :  DateTime.parse(date_boughtController.text),
      );

      final json = batteryStation.toJson();
      await docBatteryStation.set(json);

      //create batteries to the battery station
      for (int i = 1; i <= int.parse(battery_pairsController.text); i++) {
        for (int j = 0; j < 2; j++) {
          final docBattery = FirebaseFirestore.instance
              .collection('groups')
              .doc(widget.group.id)
              .collection('battery_stations')
              .doc(docBatteryStation.id)
              .collection('batteries')
              .doc();
          final battery = Battery(
            serial_number: '${serial_numberController.text}$i',
            id: docBattery.id,
            cycle: 0,
          );
          final json = battery.toJson();
          await docBattery.set(json);
        }
      }
      Utils.showSnackBarWithColor(
          'Battery Station has been added to the group', Colors.blue);
      Navigator.pop(context);
    }
  }
}
