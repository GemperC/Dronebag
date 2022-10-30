import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSettings {
  bool notifications = false;
  String id;

  UserSettings({
    required this.notifications,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        'notifications': notifications,
        "id": id,
      };

  UserSettings.fromMap(Map<String, dynamic> map())
      : assert(map()['notifications'] != null),
        assert(map()['id'] != null),
        notifications = map()['notifications'],
        id = map()['id'];

  static UserSettings fromJson(Map<String, dynamic> json) => UserSettings(
        notifications: json['notifications'],
        id: json['id'],
      );
}
