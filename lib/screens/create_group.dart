import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/models/group.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Dronebag - Create Group'),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              controller: groupNameController,
              decoration: decoration('Group Name'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(minimumSize: Size.fromHeight(60)),
                onPressed: () {
                  final group = Group(
                    groupName: groupNameController.text,
                  );
                  group.createGroup(group);
                  Navigator.pop(context);
                },
                child: Text(
                  'Create',
                  style: TextStyle(fontSize: 24),
                ))
          ],
        ),
      );

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );
}
