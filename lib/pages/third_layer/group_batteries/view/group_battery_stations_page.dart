import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/app.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/battery_repository/src/models/models.dart';
import 'package:dronebag/domain/battery_station_repository/src/models/models.dart';

import 'package:dronebag/pages/third_layer/battery_case_details/battery_case_details.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class GroupBatteryStations extends StatefulWidget {
  final String groupID;
  const GroupBatteryStations({
    Key? key,
    required this.groupID,
  }) : super(key: key);

  @override
  State<GroupBatteryStations> createState() => _GroupBatteryStationsState();
}

class _GroupBatteryStationsState extends State<GroupBatteryStations> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController serial_numberController = TextEditingController();
  final TextEditingController battery_pairsController = TextEditingController();
  final TextEditingController date_boughtController = TextEditingController();
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
                    child: Text('Something went wrong! \n\n${snapshot}',
                        style: TextStyle(color: Colors.white)),
                  );
                } else {
                  return Container(
                      child: Center(child: CircularProgressIndicator()));
                }
              }),
            )),
      ),
    );
  }

//fetch group's drones list
  Stream<List<BatteryStation>> fetchGroupBatteriesStations() {
    return FirebaseFirestore.instance
        .collection('groups/${widget.groupID}/battery_stations')
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
                      groupID: widget.groupID,
                      batteryStation: batteryStation,
                    )),
          );
        },
        // build the tile info and design
        title: Center(
          child: Padding(
            // padding betwwent he cards
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Container(
              decoration: BoxDecoration(
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
                        '${batteryStation.battrey_pairs} battery pairs',
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
                      if (serial_numberController.text.isEmpty)
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
                    controller: battery_pairsController,
                    validator: (value) {
                      if (battery_pairsController.text.isEmpty)
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
                      hintText: "Battery pairs",
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
                      if (date_boughtController.text.isEmpty)
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
                createBatteryStation();
              },
              child: Text('Add Battery stations')),
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
          .doc(widget.groupID)
          .collection('battery_stations')
          .doc();
      final batteryStation = BatteryStation(
        serial_number: serial_numberController.text,
        id: docBatteryStation.id,
        battrey_pairs: int.parse(battery_pairsController.text),
        date_bought: DateTime.parse(date_boughtController.text),
      );

      final json = batteryStation.toJson();
      await docBatteryStation.set(json);

      //create batteries to the battery station
      for (int i = 1; i <= int.parse(battery_pairsController.text); i++) {
        final docBattery = FirebaseFirestore.instance
            .collection('groups')
            .doc(widget.groupID)
            .collection('battery_stations')
            .doc(docBatteryStation.id)
            .collection('batteries')
            .doc();
        final battery = Battery(
          serial_number: '${serial_numberController.text}${i}',
          id: docBattery.id,
          cycle: 0,
        );

        final json = battery.toJson();
        await docBattery.set(json);
      }
      Utils.showSnackBarWithColor(
          'Battery Station has been added to the group', Colors.blue);
      Navigator.pop(context);
    }
  }

  
}
