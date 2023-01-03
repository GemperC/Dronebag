// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Drone {
  String id; //id of the drone in the firestore database
  String name; // name of the drone
  String serial_number; // serial number of the drone in the army
  int flight_time; // hours of active flight
  int minutes_till_maintenace; // hours left until maintnence 
  int maintenance; // every 'maintenance' hours the drone need maintenance
  DateTime date_added; // what date the drone was aded to the database
  DateTime date_bought; // when did the drone was bought

  Drone ({
    this.id = '',
    required this.name,
    required this.serial_number,
    required this.maintenance,
    required this.date_added,
    required this.date_bought,
    this.minutes_till_maintenace = 0,
    required this.flight_time,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'serial_number': serial_number,
        'maintenance': maintenance,
        'date_added': date_added,
        'date_bought': date_bought,
        'minutes_till_maintenace': minutes_till_maintenace,
        'flight_time': flight_time,
      };

  static Drone fromJson(Map<String, dynamic> json) => Drone(
        id: json['id'],
        name: json['name'],
        serial_number: json['serial_number'],
        maintenance: json['maintenance'] ,
        date_added: (json['date_added'] as Timestamp).toDate(),
        date_bought: (json['date_bought'] as Timestamp).toDate(),
        minutes_till_maintenace: json['minutes_till_maintenace'] ,
        flight_time: json['flight_time'] ,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Drone otherDrone = other as Drone;
    return otherDrone.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
