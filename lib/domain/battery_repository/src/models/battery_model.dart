// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Battery {
  String id; //id of the battery case in the firestore database
  String serial_number; // serial number of the battery case in the army
  int cycle; // how much battery pairs the case has
  DateTime? last_update;

  Battery({
    this.id = '',
    required this.serial_number,
    this.cycle = 0,
    this.last_update,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'serial_number': serial_number,
        'cycle': cycle,
        'last_update': last_update,
      };

  static Battery fromJson(Map<String, dynamic> json) => Battery(
        id: json['id'],
        serial_number: json['serial_number'],
        cycle: json['cycle'],
        last_update: json['last_update'] == null
            ? null
            : (json['last_update'] as Timestamp).toDate(),
      );
}
