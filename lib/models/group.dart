import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:dronebag/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';



class Group {
  String id;
  final String groupName;
  String groupKey;
  //UserData? user;

  Group({
    this.id = '',
    required this.groupName,
    this.groupKey = '',
    //required this.user,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'Group Name': groupName,
        'Group Key': groupKey,
        //'Users': user,
      };

  Future createGroup(Group group) async {
    final docGroup = FirebaseFirestore.instance.collection('groups').doc();
    group.id = docGroup.id;
    group.groupKey = generateGroupKey();

    final json = group.toJson();
    await docGroup.set(json);
  }

  String generateGroupKey() {
    final length = 10;
    final letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final numbers = '0123456789';

    String chars = '';
    chars += '$letters$numbers';

    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);

      return chars[indexRandom];
    }).join('');
  }
}
