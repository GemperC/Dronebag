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
                    'Cycle',
                    style: GoogleFonts.poppins(
                      color: ThemeColors.textFieldHintColor,
                      fontSize: FontSize.small,
                      fontWeight: FontWeight.w400,
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
              child: Text('Add Issue')),
        ],
      ),
    );
  }

  Widget buildBatteryStationPage(BatteryStation batteryStation) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(38.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 65, 61, 82),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Padding(
                // padding of the text in the cards
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 80,
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.center,
                                  child: Text('B1'),
                                ),
                                const SizedBox(height: 10),
                                const Align(
                                  alignment: Alignment.center,
                                  child: Text('120'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: sizedBoxHight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 80,
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: sizedBoxHight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 80,
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            Text('issues',
                style: GoogleFonts.poppins(color: ThemeColors.whiteTextColor))
          ],
        ),
      ),
    );
  }
}


/*
SingleChildScrollView(
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(38),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 65, 61, 82),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: StreamBuilder<List<Battery>>(
                      stream: fetchBatteries(),
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          final batteries = snapshot.data!;
                          batteries.sort(
                            (a, b) {
                              return a.serial_number.compareTo(b.serial_number);
                            },
                          );
                          return ListView(
                            scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children:
                                  batteries.map(buildBatteryTile).toList());
                        } else if (snapshot.hasError) {
                          return SingleChildScrollView(
                            child: Text('Something went wrong! \n\n$snapshot',
                                style: const TextStyle(color: Colors.white)),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      })),
                ),
              ],
            ),
          )),
        )

*/