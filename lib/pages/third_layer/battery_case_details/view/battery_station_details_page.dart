// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/app.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/domain/battery_repository/battery_repository.dart';
import 'package:dronebag/domain/battery_station_repository/src/models/models.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class BatteryStationDetails extends StatefulWidget {
  final String groupID;
  final BatteryStation batteryStation;
  const BatteryStationDetails({
    Key? key,
    required this.groupID,
    required this.batteryStation,
  }) : super(key: key);

  @override
  State<BatteryStationDetails> createState() => _BatteryStationDetailsState();
}

class _BatteryStationDetailsState extends State<BatteryStationDetails> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController serial_numberController = TextEditingController();
  final TextEditingController batteryIssueDetailController =
      TextEditingController();
  final TextEditingController batteryCycleController = TextEditingController();
  final TextEditingController date_boughtController = TextEditingController();
  final double sizedBoxHight = 16;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeColors.scaffoldBgColor,
          title: Text(
            "Battery Station ${widget.batteryStation.serial_number}",
            style: GoogleFonts.poppins(
              color: ThemeColors.whiteTextColor,
              fontSize: FontSize.xxLarge,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Edit Station \nDetails',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.blue,
                  fontSize: FontSize.medium,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(38),
            child: Column(children: [
              Text(
                'Batteries',
                style: GoogleFonts.poppins(
                  color: ThemeColors.textFieldHintColor,
                  fontSize: FontSize.large,
                  fontWeight: FontWeight.w600,
                ),
              ),
              StreamBuilder<List<Battery>>(
                  stream: fetchBatteries(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      final batteries = snapshot.data!;
                      batteries.sort(
                        (a, b) {
                          return a.serial_number.compareTo(b.serial_number);
                        },
                      );
                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2,
                        ),
                        itemCount: batteries.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return buildBatteryTile(batteries[index]);
                        },
                      );
                      // children:
                      //     batteries.map(buildBatteryTile).toList());
                    } else if (snapshot.hasError) {
                      return SingleChildScrollView(
                        child: Text('Something went wrong! \n\n$snapshot',
                            style: const TextStyle(color: Colors.white)),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  })),
            ]),
          ),
        ));
  }

//fetch batteries list
  Stream<List<Battery>> fetchBatteries() {
    return FirebaseFirestore.instance
        .collection(
            'groups/${widget.groupID}/battery_stations/${widget.batteryStation.id}/batteries')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Battery.fromJson(doc.data())).toList());
  }

//build the tile of the battery
  Widget buildBatteryTile(Battery battery) {
    Color batteryColor = Colors.green;
    if (battery.cycle >= 100 && battery.cycle < 150) {
      batteryColor = Colors.orange;
    } else if (battery.cycle >= 150) {
      batteryColor = Colors.red;
    }
    return ListTile(
      // go to the battery case page

      // build the tile info and design
      title: Center(
        child: Padding(
          // padding betwwent he cards
          padding: const EdgeInsets.all(8),
          child: Container(
            height: 80,
            width: 120,
            decoration: BoxDecoration(
                color: batteryColor,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Column(
              children: [
                Text(
                  battery.serial_number,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: FontSize.medium,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "Cycle: ${battery.cycle}",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: FontSize.medium,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'Issues:',
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
        batteryDetailDialog(battery);
      },
    );
  }

  Future batteryDetailDialog(Battery battery) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColors.scaffoldBgColor,
        scrollable: true,
        title: Text(
          "Battery ${battery.serial_number}",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: ThemeColors.whiteTextColor,
            fontSize: FontSize.large,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Container(
          width: 300,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Cycle: ',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: FontSize.xMedium,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    width: 60,
                    height: 50,
                    child: TextField(
                      onChanged: (value) {
                        final docBattery = FirebaseFirestore.instance
                            .collection('groups')
                            .doc(widget.groupID)
                            .collection('battery_stations')
                            .doc(widget.batteryStation.id)
                            .collection('batteries')
                            .doc(battery.id);
                        docBattery.update({'cycle': int.parse(value)});
                      },
                      controller: batteryCycleController,
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
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close')),
          TextButton(
              onPressed: () {
                //createIssue();
              },
              child: Text('Update Battery')),
        ],
      ),
    );
  }
}
