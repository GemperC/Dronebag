import 'package:cloud_firestore/cloud_firestore.dart';

class Issue {
  String id; //id of the drone in the firestore database
  String detail; // detail of the issue
  String status; // was the issue revolved
  DateTime date; // hours of active flight

  Issue ({
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

  static Issue fromJson(Map<String, dynamic> json) => Issue(
        id: json['id'],
        detail: json['detail'],
        status: json['status'],
        date: (json['date'] as Timestamp).toDate(),

      );
}
