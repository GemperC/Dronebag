// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class FlightData {
  String id; //id of the flight data in the firestore database
  String droneName;
  String droneSerial;
  String flight_purpose;
  int flight_time; // hours of active flight in the flight
  DateTime date;
  String pilot;

  FlightData({
    required this.id,
    required this.droneName,
    required this.droneSerial,
    required this.flight_purpose,
    required this.flight_time,
    required this.date,
    required this.pilot,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'droneName': droneName,
        'droneSerial': droneSerial,
        'flight_purpose': flight_purpose,
        'flight_time': flight_time,
        'date': date,
        'pilot': pilot,
      };

  static FlightData fromJson(Map<String, dynamic> json) => FlightData(
        id: json['id'],
        droneName: json['droneName'],
        droneSerial: json['droneSerial'],
        flight_purpose: json['flight_purpose'],
        flight_time: json['flight_time'],
        date: (json['date'] as Timestamp).toDate(),
        pilot: json['pilot'],
      );
}
