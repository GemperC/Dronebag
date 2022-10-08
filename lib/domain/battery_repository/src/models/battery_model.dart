import 'package:cloud_firestore/cloud_firestore.dart';

class Battery {
  String id; //id of the battery case in the firestore database
  String serial_number; // serial number of the battery case in the army
  int cycle; // how much battery pairs the case has

  Battery ({
    this.id = '',
    required this.serial_number,
    this.cycle = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'serial_number': serial_number,
        'cycle': cycle,
      };

  static Battery fromJson(Map<String, dynamic> json) => Battery(
        id: json['id'],
        serial_number: json['serial_number'],
        cycle: json['cycle'] ,
      );
}
