import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/domain/battery_issue_repository/battery_issue_repository.dart';
import 'package:dronebag/domain/battery_repository/battery_repository.dart';
import 'package:dronebag/domain/battery_station_issue_repository/battery_station_issue_repository.dart';
import 'package:dronebag/domain/battery_station_repository/battery_station_repository.dart';
import 'package:dronebag/widgets/utils.dart';
import 'package:flutter/material.dart';

class FirestoreCreate {
  String groupID;
  BatteryStation batteryStation;

  FirestoreCreate({
    required this.groupID,
    required this.batteryStation,
  });

//==========CREATE BATTERY ISSUE===========//
  Future createBatteryIssue(Battery battery) async {
    final docBatteryIssue = FirebaseFirestore.instance
        .collection('groups')
        .doc(groupID)
        .collection('battery_stations')
        .doc(batteryStation.id)
        .collection('batteries')
        .doc(battery.id)
        .collection('battery_issues')
        .doc();
    final batteryIssue = BatteryIssue(
      detail: "",
      id: docBatteryIssue.id,
      date: DateTime.now(),
      status: 'open',
    );

    final json = batteryIssue.toJson();
    await docBatteryIssue.set(json);
    Utils.showSnackBarWithColor(
        'New issue has been added to the battery', Colors.blue);
  }

//==========CREATE BATTERY STATION ISSUE===========//
  Future createBatteryStationIssue() async {
    final docbatteryStationIssue = FirebaseFirestore.instance
        .collection('groups')
        .doc(groupID)
        .collection('battery_stations')
        .doc(batteryStation.id)
        .collection('issues')
        .doc();
    final batteryStationIssue = BatteryStationIssue(
      detail: "",
      id: docbatteryStationIssue.id,
      date: DateTime.now(),
      status: 'open',
    );

    final json = batteryStationIssue.toJson();
    await docbatteryStationIssue.set(json);
    Utils.showSnackBarWithColor(
        'New issue has been added to the station', Colors.blue);
  }

}
