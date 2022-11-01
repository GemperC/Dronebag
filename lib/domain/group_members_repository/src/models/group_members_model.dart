import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/domain/user_repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupMember {
  final String role;
  final UserData user;

  GroupMember({
    required this.role,
    required this.user,
  });

  Map<String, dynamic> toJson() => {
        'role': role,
        'user': user,
      };

  GroupMember.fromMap(Map<String, dynamic> map())
      : assert(map()['role'] != null),
        assert(map()['user'] != null),
        assert(map()['Phone_Number'] != null),
        role = map()['role'],
        user = map()['user'];

  static GroupMember fromJson(Map<String, dynamic> json) => GroupMember(
        role: json['role'],
        user: json['user'],
      );
}
