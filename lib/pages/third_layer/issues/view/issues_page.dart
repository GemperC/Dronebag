// ignore_for_file: depend_on_referenced_packages, sized_box_for_whitespace, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/app.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/domain/issue_repository/issue_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class Issues extends StatefulWidget {
  final String groupID;
  final String droneID;
  const Issues({
    Key? key,
    required this.groupID,
    required this.droneID,
  }) : super(key: key);

  @override
  State<Issues> createState() => _IssuesState();
}

class _IssuesState extends State<Issues> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController issueDetailController = TextEditingController();
  final TextEditingController issueDateController = TextEditingController();

  final double sizedBoxHight = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.scaffoldBgColor,
        title: Text(
          "Issues",
          style: GoogleFonts.poppins(
            color: ThemeColors.whiteTextColor,
            fontSize: FontSize.xxLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'Add New\nIssue',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.blue,
                fontSize: FontSize.medium,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              addIssueDialog();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(30),
            child: StreamBuilder<List<Issue>>(
              stream: fetchGroupDroneIssues(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final issues = snapshot.data!;
                  //print(issues.length);
                  return ListView(
                      children: issues.map(buildIssueTile).toList());
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
  Stream<List<Issue>> fetchGroupDroneIssues() {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupID)
        .collection('drones')
        .doc(widget.droneID)
        .collection('issues')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Issue.fromJson(doc.data())).toList());
  }

//build the tile of the drone
  Widget buildIssueTile(Issue issue) {
    return ListTile(
      onTap: () {},
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 80,
          width: 250,
          decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Center(
            child: Column(
              children: [
                Text(
                  issue.detail,
                  style: GoogleFonts.poppins(
                    color: ThemeColors.whiteTextColor,
                    fontSize: FontSize.large,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Status:  ${issue.status}',
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
  Future addIssueDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColors.scaffoldBgColor,
        scrollable: true,
        title: Text(
          "Add New Issue",
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
                    controller: issueDetailController,
                    validator: (value) {
                      if (issueDetailController.text.isEmpty) {
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
                      hintText: "Issue Detail",
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
                    controller: issueDateController,
                    onShowPicker: ((context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                    }),
                    validator: (value) {
                      if (issueDateController.text.isEmpty) {
                        return "This field can't be empty";
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
                      hintText: "Date of the issue",
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
                createIssue();
              },
              child: const Text('Add Issue')),
        ],
      ),
    );
  }

//create a new drone and add it to the group
  Future createIssue() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      final docIssue = FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupID)
          .collection('drones')
          .doc(widget.droneID)
          .collection('issues')
          .doc();
      final issue = Issue(
        detail: issueDetailController.text.trim(),
        id: docIssue.id,
        date: DateTime.parse(issueDateController.text),
        status: 'open',
      );

      final json = issue.toJson();
      await docIssue.set(json);
      Utils.showSnackBarWithColor(
          'New issue has been added to the drone', Colors.blue);
      Navigator.pop(context);
    }
  }


}
