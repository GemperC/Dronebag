import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/pages/third_layer/group_main/widgets/getGroupKey.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CopyGroupKey extends StatefulWidget {
  final String groupID;
  const CopyGroupKey({
    Key? key,
    required this.groupID,
  }) : super(key: key);

  @override
  State<CopyGroupKey> createState() => _CopyGroupKeyState();
}

class _CopyGroupKeyState extends State<CopyGroupKey> {
  
  
  final group =
      FirebaseFirestore.instance.collection('groups').doc();

  @override
  build(BuildContext context) {
    return FutureBuilder<Group?>(
      future: readGroup(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          final group = snapshot.data;

          return group == null ? CircularProgressIndicator() : Text('group');
        }
        return CircularProgressIndicator();
      }),
    );
  }


  readGroup() async {
    final groupDoc = FirebaseFirestore.instance
        .collection('groups').doc(widget.groupID);
    final snapshot = await groupDoc.get();

    if (snapshot.exists) {
      return Group.fromJson(snapshot.data()!);
      
    }
  }

  String getGroupKey(Group group) => group.key;

}
