import 'package:cloud_firestore/cloud_firestore.dart';

class BatteryIssue {
  String id; //id of the drone in the firestore database
  String detail; // detail of the BatteryIssue
  String status; // was the BatteryIssue revolved
  DateTime date; // hours of active flight

  BatteryIssue({
    this.id = '',
    required this.detail,
    this.status = 'open',
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'detail': detail,
        'status': status,
        'date': date,
      };

  static BatteryIssue fromJson(Map<String, dynamic> json) => BatteryIssue(
        id: json['id'],
        detail: json['detail'],
        status: json['status'],
        date: (json['date'] as Timestamp).toDate(),
      );
}
