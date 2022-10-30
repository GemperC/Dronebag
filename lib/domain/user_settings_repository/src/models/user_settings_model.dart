import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSettings {
  bool notifications = false;

  UserSettings({
    required this.notifications,
  });

  Map<String, dynamic> toJson() => {
        'notifications': notifications,
      };

  UserSettings.fromMap(Map<String, dynamic> map())
      : assert(map()['notifications'] != null),
        notifications = map()['notifications'];

  static UserSettings fromJson(Map<String, dynamic> json) => UserSettings(
        notifications: json['notifications'],
      );
}
