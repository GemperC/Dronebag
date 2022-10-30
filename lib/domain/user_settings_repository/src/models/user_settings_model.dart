import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSettings {
  bool notifications;
  String id;
  String group;

  UserSettings({
    this.notifications = false,
    required this.id,
    this.group = '',
  });

  Map<String, dynamic> toJson() => {
        'notifications': notifications,
        "id": id,
        "group": group,
      };

  UserSettings.fromMap(Map<String, dynamic> map())
      : assert(map()['notifications'] != null),
        assert(map()['id'] != null),
        assert(map()['group'] != null),
        notifications = map()['notifications'],
        id = map()['id'],
        group = map()['group'];

  static UserSettings fromJson(Map<String, dynamic> json) => UserSettings(
        notifications: json['notifications'],
        id: json['id'],
        group: json['group'],
      );
}
