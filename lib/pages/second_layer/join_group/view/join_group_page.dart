import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/models/group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class JoinGroupPage extends StatefulWidget {
  const JoinGroupPage({Key? key}) : super(key: key);

  @override
  State<JoinGroupPage> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final groupKeyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dronebag - Join Group'),
      ),
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: groupKeyController,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                labelText: 'Ender Group Key',
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 3, color: Colors.grey), //<-- SEE HERE
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(minimumSize: Size.fromHeight(60)),
                onPressed: () {
                  final group = findGroupIDFromKey("key");
                  if (group == "not_found") {
                    return;
                  } else {}
                },
                child: Text(
                  'Enter',
                  style: TextStyle(fontSize: 24),
                ))
          ],
        ),
      ),
    );
  }

  findGroupIDFromKey(String key) {
    return 'groupID';
  }

  Future createGroup(Group group) async {
    final docGroup = FirebaseFirestore.instance.collection('groups').doc();
    group.group_admins.add(user.email!);

    final json = group.toJson();
    await docGroup.set(json);
  }
}
