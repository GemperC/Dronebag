import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetGroupKey extends StatefulWidget {
  final String groupID;
  const GetGroupKey({
    Key? key,
    required this.groupID,
  }) : super(key: key);

  @override
  State<GetGroupKey> createState() => _GetGroupKeyState();
}

class _GetGroupKeyState extends State<GetGroupKey> {
  
  
  final group =
      FirebaseFirestore.instance.collection('groups').doc();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Group?>(
      future: readGroup(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          final group = snapshot.data;

          return group == null ? CircularProgressIndicator() : getGroupKey(group);
        }
        return CircularProgressIndicator();
      }),
    );
  }


  Future<Group?> readGroup() async {
    final groupDoc = FirebaseFirestore.instance
        .collection('groups').doc(widget.groupID);
    final snapshot = await groupDoc.get();

    if (snapshot.exists) {
      return Group.fromJson(snapshot.data()!);
    }
  }

  Widget getGroupKey(Group group) => Text(
        group.key,
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: FontSize.large,
          fontWeight: FontWeight.w600,
        ),
      );

}