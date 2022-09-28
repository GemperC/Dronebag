import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/app.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/domain/issue_repository/issue_repository.dart';
import 'package:dronebag/domain/maintnance_history_repository/maintnance_history_repository.dart';
import 'package:dronebag/domain/user_repository/user_repository.dart';
import 'package:dronebag/pages/third_layer/drone_details/view/view.dart';
import 'package:dronebag/pages/third_layer/group_members/view/view.dart';
import 'package:dronebag/widgets/main_button_2.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class MaintenanceRecords extends StatefulWidget {
  final String groupID;
  final String droneID;
  const MaintenanceRecords({
    Key? key,
    required this.groupID,
    required this.droneID,
  }) : super(key: key);

  @override
  State<MaintenanceRecords> createState() => _MaintenanceRecordsState();
}

class _MaintenanceRecordsState extends State<MaintenanceRecords> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController maintenanceDetailController =
      TextEditingController();
  final TextEditingController maintenanceDateController =
      TextEditingController();

  final double sizedBoxHight = 16;

  @override
  void dispose() {
    maintenanceDateController.dispose();
    maintenanceDetailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.scaffoldBgColor,
        title: Text(
          "Maintenance History",
          style: GoogleFonts.poppins(
            color: ThemeColors.whiteTextColor,
            fontSize: FontSize.xxLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'Add New\nRecord',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.blue,
                fontSize: FontSize.medium,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              addMaintenanceRecordDialog();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(30),
            child: StreamBuilder<List<Maintenance>>(
              stream: fetchGroupDroneMaintenances(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final records = snapshot.data!;
                  //print(issues.length);
                  return ListView(
                      children: records.map(buildRecordTile).toList());
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
  Stream<List<Maintenance>> fetchGroupDroneMaintenances() {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupID)
        .collection('drones')
        .doc(widget.droneID)
        .collection('maintenance_history')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Maintenance.fromJson(doc.data()))
            .toList());
  }

//build the tile of the drone
  Widget buildRecordTile(Maintenance record) {
    return ListTile(
      onTap: () {},
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 80,
          width: 250,
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Center(
            child: Column(
              children: [
                Text(
                  '${record.detail}',
                  style: GoogleFonts.poppins(
                    color: ThemeColors.whiteTextColor,
                    fontSize: FontSize.large,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${record.date}',
                  style: GoogleFonts.poppins(
                    color: ThemeColors.whiteTextColor,
                    fontSize: FontSize.large,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// dialog to add new drones to the group
  Future addMaintenanceRecordDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColors.scaffoldBgColor,
        scrollable: true,
        title: Text(
          "Add New Record",
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
                    controller: maintenanceDetailController,
                    validator: (value) {
                      if (maintenanceDetailController.text.isEmpty)
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
                      hintText: "Maintenance Detail",
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
                    controller: maintenanceDateController,
                    onShowPicker: ((context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                    }),
                    validator: (value) {
                      if (maintenanceDateController.text.isEmpty)
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
                      hintText: "Date of the maintenance",
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
                createMaintenanceHistoryRecord();
              },
              child: Text('Add Record')),
        ],
      ),
    );
  }

// create a new drone and add it to the group
  Future createMaintenanceHistoryRecord() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      final docRecord = FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupID)
          .collection('drones')
          .doc(widget.droneID)
          .collection('maintenance_history')
          .doc();
      final record = Maintenance(
        detail: maintenanceDetailController.text.trim(),
        id: docRecord.id,
        date: DateTime.parse(maintenanceDateController.text),
      );

      final json = record.toJson();
      await docRecord.set(json);
      Utils.showSnackBarWithColor(
          'New issue has been added to the drone', Colors.blue);
      Navigator.pop(context);
    }
  }
}
