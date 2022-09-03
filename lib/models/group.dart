import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  String id;
  final String groupName;

  Group({
    this.id = '',
    required this.groupName,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'Group Name': groupName,
      };


    Future createGroup(Group group) async {
      final docGroup = FirebaseFirestore.instance.collection('groups').doc();
      group.id = docGroup.id;

      final json = group.toJson();
      await docGroup.set(json);
  }
}
