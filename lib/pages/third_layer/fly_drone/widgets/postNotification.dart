import 'dart:async';
import 'dart:convert' show Encoding, json;
import 'package:http/http.dart' as http;

class PostCall {
  final postUrl = 'https://fcm.googleapis.com/fcm/send';

  final data = {
    "notification": {"body": "this is a body", "title": "this is a title"},
    "priority": "high",
    "data": {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done"
    },
    "to": "f1C9UvLrR7uu_RN69LXuD2:APA91bHFZuJ622zlg529AvttOcS0d17ZenUjZ7xc9rZiZY9fBrh2Xq1quFwTKklb5DjiFOyimTGOZe6wu61JAdReD8JL385ySoJ21yPK1K6Zx3ssUp_NNrfNh1EBx7ouxcG1v88qedLL"
  };

  Future<bool> makeCall() async {
    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=AAAAksIRG_g:APA91bHSF8IAwnFTcUpYlqvZpGT1vzhfsDR7XeCfQfrSUydQWZqDI7SVzRBuCl90CMp6xp_wOLqZ3x2MblT-SH1RKbACcX3RQFHHYqp0efb2Y8M1zhY0-e6E3e32c2_PVs_QbKIrjqpr'
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