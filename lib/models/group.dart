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




}
