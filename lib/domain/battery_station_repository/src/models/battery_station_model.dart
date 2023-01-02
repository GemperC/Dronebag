// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class BatteryStation {
  String id; //id of the battery case in the firestore database
  String serial_number; // serial number of the battery case in the army
  String ownership; // serial number of the battery case in the army

  int battery_pairs; // how much battery pairs the case has
  DateTime date_bought; // when did the battery case was purchased

  BatteryStation({
    this.id = '',
    required this.serial_number,
    required this.ownership,
    required this.date_bought,
    this.battery_pairs = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'serial_number': serial_number,
        'battery_pairs': battery_pairs,
        'date_bought': date_bought,
        'ownership': ownership,
      };

  static BatteryStation fromJson(Map<String, dynamic> json) => BatteryStation(
        id: json['id'],
        serial_number: json['serial_number'],
        date_bought: (json['date_bought'] as Timestamp).toDate(),
        battery_pairs: json['battery_pairs'],
        ownership: json['ownership'],
      );
}
