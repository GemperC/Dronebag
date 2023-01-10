// ignore_for_file: unnecessary_new

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:dronebag/domain/issue_repository/issue_repository.dart';
import 'package:dronebag/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const List<String> list = <String>['open', 'closed'];

class DroneIssues extends StatefulWidget {
  final String groupID;
  final Drone drone;
  const DroneIssues({
    Key? key,
    required this.groupID,
    required this.drone,
  }) : super(key: key);

  @override
  State<DroneIssues> createState() => _DroneIssuesState();
}

class _DroneIssuesState extends State<DroneIssues> {
  String dropdownValue = "issue.status";
  TextEditingController issueDetailController = new TextEditingController();
  TextEditingController issueStatusController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
          createIssue();
        },
      ),
      StreamBuilder<List<Issue>>(
          stream: fetchGroupDroneIssues(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final droneIssues = snapshot.data!;
              return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: droneIssues.length,
                  itemBuilder: (context, index) {
                    issueDetailController =
                        TextEditingController(text: droneIssues[index].detail);
                    return issueTile(droneIssues[index], issueDetailController);
                  });
            } else if (snapshot.hasError) {
              return SingleChildScrollView(
                child: Text('Something went wrong! \n\n$snapshot',
                    style: const TextStyle(color: Colors.white)),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    ]);
  }

  Future createIssue() async {
    final docIssue = FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupID)
        .collection('drones')
        .doc(widget.drone.id)
        .collection('issues')
        .doc();
    final issue = Issue(
      detail: "",
      id: docIssue.id,
      date: DateTime.now(),
      status: 'open',
    );

    final json = issue.toJson();
    await docIssue.set(json);
    Utils.showSnackBarWithColor(
        'New issue has been added to the drone', Colors.blue);
  }

  Stream<List<Issue>> fetchGroupDroneIssues() {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupID)
        .collection('drones')
        .doc(widget.drone.id)
        .collection('issues')
        .orderBy("date", descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Issue.fromJson(doc.data())).toList());
  }

  Widget issueTile(Issue issue, TextEditingController issueDetailController) {
    String issueDescription = issue.detail;
    Color textDescriptionColor = ThemeColors.whiteTextColor;
    if (issue.detail == "") {
      issueDescription = "Click here to add description";
      textDescriptionColor = ThemeColors.greyTextColor;
    }

    return ListTile(
      onTap: (() {
        setState(() {
          dropdownValue = issue.status;
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: ThemeColors.scaffoldBgColor,
            scrollable: true,
            title: Center(
              child: Text(
                "Edit issue description",
                style: GoogleFonts.poppins(
                  color: ThemeColors.whiteTextColor,
                  fontSize: FontSize.large,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            content: Column(
              children: [
                TextFormField(
                  controller: issueDetailController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: GoogleFonts.poppins(
                    color: ThemeColors.whiteTextColor,
                    fontSize: FontSize.medium,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    fillColor: ThemeColors.textFieldBgColor,
                    filled: true,
                    hintText: "Issue description",
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
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Text(
                        'Status:   ',
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                                                width: 80,

                        child: DropdownButtonFormField<String>(
                          elevation: 16,
                          style: GoogleFonts.poppins(
                            color: ThemeColors.greyTextColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w600,
                          ),
                          items:
                              list.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: dropdownValue,
                          onChanged: (String? value) {
                            dropdownValue = value!;
                          },
                          // onSaved: (value) {
                          //   setState(() {
                          //     dropdownValue = value!;
                          //   });
                          // },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    final docBatteryStationIssue = FirebaseFirestore.instance
                        .collection('groups')
                        .doc(widget.groupID)
                        .collection('drones')
                        .doc(widget.drone.id)
                        .collection('issues')
                        .doc(issue.id);
                    docBatteryStationIssue.update({
                      'detail': issueDetailController.text,
                      'status': dropdownValue
                    });
                    Navigator.pop(context);
                    Utils.showSnackBarWithColor(
                        'Issue has been updated', Colors.blue);
                  },
                  child: const Text(
                    'Update issue',
                    style: TextStyle(color: Colors.blue),
                  )),
            ],
          ),
        );
      }),
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
                      '${issue.date.day}-${issue.date.month}-${issue.date.year}',
                      style: GoogleFonts.poppins(
                        color: ThemeColors.whiteTextColor,
                        fontSize: FontSize.medium,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      issueDescription,
                      style: GoogleFonts.poppins(
                        color: textDescriptionColor,
                        fontSize: FontSize.medium,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Status:  ${issue.status}',
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
                          color: Colors.red,
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
                                              .collection('drones')
                                              .doc(widget.drone.id)
                                              .collection("issues")
                                              .doc(issue.id)
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
