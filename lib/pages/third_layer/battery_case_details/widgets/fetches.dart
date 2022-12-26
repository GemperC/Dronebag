import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/domain/battery_issue_repository/battery_issue_repository.dart';
import 'package:dronebag/domain/battery_repository/battery_repository.dart';
import 'package:dronebag/domain/battery_station_issue_repository/battery_station_issue_repository.dart';
import 'package:dronebag/domain/battery_station_repository/battery_station_repository.dart';

class FirestoreFetch {
  String groupID;
  BatteryStation batteryStation;

  FirestoreFetch({
    required this.groupID,
    required this.batteryStation,
  });

//==========FETCH BATTERIES===========//
  Stream<List<Battery>> fetchBatteries() {
    return FirebaseFirestore.instance
        .collection(
            'groups/$groupID/battery_stations/${batteryStation.id}/batteries')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Battery.fromJson(doc.data())).toList());
  }

//==========FETCH BATTERY ISSUES===========//
  Stream<List<BatteryIssue>> fetchBatteryIssue(Battery battery) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupID)
        .collection('battery_stations')
        .doc(batteryStation.id)
        .collection('batteries')
        .doc(battery.id)
        .collection('battery_issues')
        .orderBy("date", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BatteryIssue.fromJson(doc.data()))
            .toList());
  }

//==========FETCH BATTERIES STATION ISSUES===========//
  Stream<List<BatteryStationIssue>> fetchBatteryStationIssue() {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupID)
        .collection('battery_stations')
        .doc(batteryStation.id)
        .collection('issues')
        .orderBy("date", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BatteryStationIssue.fromJson(doc.data()))
            .toList());
  }
}
