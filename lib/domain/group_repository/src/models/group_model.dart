import 'dart:ffi';

import 'package:dronebag/domain/user_repository/src/models/models.dart';

class Group {
  String id;
  final String name;
  String key;
  Map<String, String> users;

  Group({
    this.id = '',
    required this.name,
    this.key = '',
    required this.users,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'Group_Name': name,
        'Group_Key': key,
        'Group_Users': users,
      };

  static Group fromJson(Map<String, dynamic> json) => Group(
        id: json['id'],
        name: json['Group_Name'],
        key: json['Group_key'],
        users: json['Group_Admins'],
      );
}
