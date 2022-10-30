import 'dart:async';
import 'dart:convert' show Encoding, json;
import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:http/http.dart' as http;

class PostCall {
  String topic;
  String pilot;
  List<Drone> drones;

  PostCall({
    required this.topic,
    required this.pilot,
    required this.drones,
  });

  final postUrl = 'https://fcm.googleapis.com/fcm/send';

  Future<bool> makeCall() async {
    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAksIRG_g:APA91bHSF8IAwnFTcUpYlqvZpGT1vzhfsDR7XeCfQfrSUydQWZqDI7SVzRBuCl90CMp6xp_wOLqZ3x2MblT-SH1RKbACcX3RQFHHYqp0efb2Y8M1zhY0-e6E3e32c2_PVs_QbKIrjqpr'
    };
    final data = {
      "notification": {
        "title": "$pilot started a flight!",
        "body": "$pilot is flying the drones:\n${drones.map((drone) {
          drone.name;
        })}",
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
      "to": "/topics/$topic"
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      return true;
    } else {
      // on failure do sth
      return false;
    }
  }
}
