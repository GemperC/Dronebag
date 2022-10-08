import 'package:cloud_firestore/cloud_firestore.dart';

class BatteryIssue {
  String id; //id of the drone in the firestore database
  String detail; // detail of the BatteryIssue
  String resolved; // was the BatteryIssue revolved
  DateTime date; // hours of active flight

  BatteryIssue ({
    this.id = '',
    required this.detail,
    this.resolved = 'no',
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'detail': detail,
        'resolved': resolved,
        'date': date,
      };

  static BatteryIssue fromJson(Map<String, dynamic> json) => BatteryIssue(
        id: json['id'],
        detail: json['detail'],
        resolved: json['resolved'],
        date: (json['date'] as Timestamp).toDate(),

      );
}