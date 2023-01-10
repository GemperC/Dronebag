// ignore_for_file: file_names, depend_on_referenced_packages, unused_local_variable, unused_shown_name

import 'dart:async';
import 'dart:convert' show Encoding, json;
import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:http/http.dart' as http;

class PostCall {
  String topic;
  String purpose;
  String pilot;
  List<Drone> drones;

  PostCall({
    required this.topic,
    required this.purpose,
    required this.pilot,
    required this.drones, 
  });

  final postUrl = 'https://fcm.googleapis.com/fcm/send';

  Future<http.Response> makeCallStartFlight() async {
  const String url = 'https://fcm.googleapis.com/fcm/send';
  const String serverKey = 'AAAAksIRG_g:APA91bHSF8IAwnFTcUpYlqvZpGT1vzhfsDR7XeCfQfrSUydQWZqDI7SVzRBuCl90CMp6xp_wOLqZ3x2MblT-SH1RKbACcX3RQFHHYqp0efb2Y8M1zhY0-e6E3e32c2_PVs_QbKIrjqpr';
  final String groupTopic = '/topics/$topic';

  final Map<String, dynamic> message = {
    'notification': {
      'title': "$pilot started a $purpose flight!",
      'body': "$pilot is flying the drones:\n${drones.map((e) => e.name)}",
    },
    'to': groupTopic
  };

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey'
  };

  final http.Response response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: json.encode(message),
  );

  return response;
}

  Future<http.Response> makeCallEndFlight() async {
  const String url = 'https://fcm.googleapis.com/fcm/send';
  const String serverKey = 'AAAAksIRG_g:APA91bHSF8IAwnFTcUpYlqvZpGT1vzhfsDR7XeCfQfrSUydQWZqDI7SVzRBuCl90CMp6xp_wOLqZ3x2MblT-SH1RKbACcX3RQFHHYqp0efb2Y8M1zhY0-e6E3e32c2_PVs_QbKIrjqpr';
  final String groupTopic = '/topics/$topic';

  final Map<String, dynamic> message = {
    'notification': {
        "title": "$pilot ended the $purpose flight",
        "body": "$pilot was flying the drones:\n${drones.map((e) => e.name)}",
    },
    'to': groupTopic
  };

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey'
  };

  final http.Response response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: json.encode(message),
  );

  return response;
}

  // Future<void> makeCallStartFlight() async {
  //   final headers = {
  //     'content-type': 'application/json',
  //     'Authorization':
  //         'key=AAAAksIRG_g:APA91bHSF8IAwnFTcUpYlqvZpGT1vzhfsDR7XeCfQfrSUydQWZqDI7SVzRBuCl90CMp6xp_wOLqZ3x2MblT-SH1RKbACcX3RQFHHYqp0efb2Y8M1zhY0-e6E3e32c2_PVs_QbKIrjqpr'
  //   };
  //   final data = {
  //     "notification": {
  //       "title": "$pilot started a $purpose flight!",
  //       "body": "$pilot is flying the drones:\n${drones.map((e) => e.name)}",
  //     },
  //     "priority": "high",
  //     "data": {
  //       "click_action": "FLUTTER_NOTIFICATION_CLICK",
  //       "id": "1",
  //       "status": "done"
  //     },
  //     "to": "/topics/$topic"
  //   };
  //   // print('=========seding============');
  //   final response = await http.post(Uri.parse(postUrl),
  //       body: json.encode(data),
  //       encoding: Encoding.getByName('utf-8'),
  //       headers: headers);
  // }


  // Future<void> makeCallEndFlight() async {
  //   final headers = {
  //     'content-type': 'application/json',
  //     'Authorization':
  //         'key=AAAAksIRG_g:APA91bHSF8IAwnFTcUpYlqvZpGT1vzhfsDR7XeCfQfrSUydQWZqDI7SVzRBuCl90CMp6xp_wOLqZ3x2MblT-SH1RKbACcX3RQFHHYqp0efb2Y8M1zhY0-e6E3e32c2_PVs_QbKIrjqpr'
  //   };
  //   final data = {
  //     "notification": {
  //       "title": "$pilot ended the $purpose flight",
  //       "body": "$pilot was flying the drones:\n${drones.map((e) => e.name)}",
  //     },
  //     "priority": "high",
  //     "data": {
  //       "click_action": "FLUTTER_NOTIFICATION_CLICK",
  //       "id": "1",
  //       "status": "done"
  //     },
  //     "to": "/topics/$topic"
  //   };
  //   // print('=========seding============');
  //   final response = await http.post(Uri.parse(postUrl),
  //       body: json.encode(data),
  //       encoding: Encoding.getByName('utf-8'),
  //       headers: headers);
  // }
}
