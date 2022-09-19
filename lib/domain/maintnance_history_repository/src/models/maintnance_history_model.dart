import 'package:cloud_firestore/cloud_firestore.dart';

class Maintenance {
  String id; //id of the drone in the firestore database
  String detail; // detail of the issue was the issue revolved
  DateTime date; // hours of active flight

  Maintenance({
    this.id = '',
    required this.detail,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'detail': detail
      };

  static Maintenance fromJson(Map<String, dynamic> json) =>
      Maintenance(
        id: json['id'],
        detail: json['detail'],
        date: (json['date'] as Timestamp).toDate(),
      );
}
