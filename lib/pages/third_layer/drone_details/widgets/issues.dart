import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:dronebag/domain/issue_repository/issue_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<List<Issue>>(
            stream: fetchGroupDroneIssues(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final droneIssues = snapshot.data!.first;
                return Column(
                  children: [
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
                      onPressed: () {},
                    ),
                    //ADD LISTVIEW BUIDLER HERE
                  ],
                );
              } else if (snapshot.hasError) {
                return SingleChildScrollView(
                  child: Text('Something went wrong! \n\n$snapshot',
                      style: const TextStyle(color: Colors.white)),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Stream<List<Issue>> fetchGroupDroneIssues() {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupID)
        .collection('drones')
        .doc(widget.drone.id)
        .collection('issues')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Issue.fromJson(doc.data())).toList());
  }
}
