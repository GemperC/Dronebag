import 'package:cloud_firestore/cloud_firestore.dart';

class BatteryStationIssue {
  String id; //id of the drone in the firestore database
  String detail; // detail of the issue
  String status; // was the issue revolved
  DateTime date; // hours of active flight

  BatteryStationIssue ({
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

  static BatteryStationIssue fromJson(Map<String, dynamic> json) => BatteryStationIssue(
        id: json['id'],
        detail: json['detail'],
        status: json['status'],
        date: (json['date'] as Timestamp).toDate(),

      );
}
