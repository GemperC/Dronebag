import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetGroupInfo extends StatefulWidget {
  final String groupID;
  const GetGroupInfo({
    Key? key,
    required this.groupID,
  }) : super(key: key);

  @override
  State<GetGroupInfo> createState() => _GetGroupInfoState();
}

class _GetGroupInfoState extends State<GetGroupInfo> {
  
  
  final group =
      FirebaseFirestore.instance.collection('groups').doc();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Group?>(
      future: readGroup(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          final group = snapshot.data;

          return group == null ? Text('Something when wrong') : getGroupName(group);
        }
        return Text('Something when wrong');
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

  Widget getGroupName(Group group) => Text(
        group.name,
        style: GoogleFonts.poppins(
          color: ThemeColors.whiteTextColor,
          fontSize: FontSize.xxLarge,
          fontWeight: FontWeight.w600,
        ),
      );

}
