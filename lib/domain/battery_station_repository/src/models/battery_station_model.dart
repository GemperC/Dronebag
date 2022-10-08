import 'package:cloud_firestore/cloud_firestore.dart';

class BatteryStation {
  String id; //id of the battery case in the firestore database
  String serial_number; // serial number of the battery case in the army
  int battrey_pairs; // how much battery pairs the case has
  DateTime date_bought; // when did the battery case was purchased

  BatteryStation ({
    this.id = '',
    required this.serial_number,
    required this.date_bought,
    this.battrey_pairs = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'serial_number': serial_number,
        'battrey_pairs': battrey_pairs,
        'date_bought': date_bought,
      };

  static BatteryStation fromJson(Map<String, dynamic> json) => BatteryStation(
        id: json['id'],
        serial_number: json['serial_number'],
        date_bought: (json['date_bought'] as Timestamp).toDate(),
        battrey_pairs: json['battrey_pairs'] ,
      );
}
