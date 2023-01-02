// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace, unnecessary_new
import 'package:dronebag/app.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/domain/battery_repository/battery_repository.dart';
import 'package:dronebag/domain/battery_station_issue_repository/battery_station_issue_repository.dart';
import 'package:dronebag/domain/battery_station_repository/src/models/models.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/widgest.dart';

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
  final TextEditingController batteryCycleController = TextEditingController();
  final TextEditingController date_boughtController = TextEditingController();
  final double sizedBoxHight = 16;
  final TextEditingController battery_pairsController = TextEditingController();
  TextEditingController batteryStationIssueDetailController =
      new TextEditingController();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    batteryStationIssueDetailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fetch = FirestoreFetch(
        groupID: widget.groupID, batteryStation: widget.batteryStation);
    final create = FirestoreCreate(
        groupID: widget.groupID, batteryStation: widget.batteryStation);
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
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => EditBatteryStationDialog(
                          batteryStation: widget.batteryStation,
                          groupID: widget.groupID,
                        ));
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(38, 20, 38, 38),
            child: Column(
              children: [
              Text(
                'Ownership: ${widget.batteryStation.ownership}',
                style: GoogleFonts.poppins(
                  color: ThemeColors.textFieldHintColor,
                  fontSize: FontSize.medium,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Batteries',
                style: GoogleFonts.poppins(
                  color: ThemeColors.textFieldHintColor,
                  fontSize: FontSize.large,
                  fontWeight: FontWeight.w600,
                ),
              ),
              StreamBuilder<List<Battery>>(
                  stream: fetch.fetchBatteries(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      final batteries = snapshot.data!;
                      batteries.sort(
                        (a, b) {
                          return a.serial_number.compareTo(b.serial_number);
                        },
                      );
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.8,
                        ),
                        itemCount: batteries.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return BatteryTile(
                              battery: batteries[index],
                              batteryStation: widget.batteryStation,
                              groupID: widget.groupID);
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
                  })),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      style: GoogleFonts.poppins(
                        color: ThemeColors.textFieldHintColor,
                        fontSize: FontSize.large,
                        fontWeight: FontWeight.w600,
                      ),
                      text: "Station's Issue list ",
                    ),
                    const WidgetSpan(
                        child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    )),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          create.createBatteryStationIssue();
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
              const SizedBox(height: 12),
              StreamBuilder<List<BatteryStationIssue>>(
                stream: fetch.fetchBatteryStationIssue(),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    final batteryStationIssues = snapshot.data!;
                    //print(issues.length);
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: batteryStationIssues.length,
                      itemBuilder: (context, index) {
                        batteryStationIssueDetailController =
                            TextEditingController(
                                text: batteryStationIssues[index].detail);
                        return BatteryStationIssueTile(
                            batteryStationIssueDetailController:
                                batteryStationIssueDetailController,
                            groupID: widget.groupID,
                            batteryStation: widget.batteryStation,
                            batteryStationIssue: batteryStationIssues[index]);
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
                }),
              ),
            ]),
          ),
        ));
  }
}
