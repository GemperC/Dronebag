import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/domain/user_repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupMember {
  final String role;
  final DocumentReference user;
  final String email;

  GroupMember({
    required this.role,
    required this.user,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'role': role,
        'user': user,
        'email': email,
      };

  GroupMember.fromMap(Map<String, dynamic> map())
      : assert(map()['role'] != null),
        assert(map()['user'] != null),
        assert(map()['email'] != null),
        role = map()['role'],
        user = map()['user'],
        email = map()['email'];

  static GroupMember fromJson(Map<String, dynamic> json) => GroupMember(
        role: json['role'],
        user: json['user'],
        email: json['email'],
      );
}
