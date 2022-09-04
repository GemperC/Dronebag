import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:dronebag/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Group {
  String id;
  final String groupName;
  String groupKey;
  List<String> group_users;
  List<String> group_admins;
  //UserData? user;

  Group({
    this.id = '',
    required this.groupName,
    this.groupKey = '',
    required this.group_admins ,
    required this.group_users ,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'Group Name': groupName,
        'Group Key': groupKey,
        'Group Users': group_users,
        'Group Admins': group_admins,
        //'Users': user,
      };
}
