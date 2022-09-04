import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/models/group.dart';
import 'package:dronebag/models/user.dart';
import 'package:dronebag/screens/group_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final user = FirebaseAuth.instance.currentUser!;

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
                  //UserData user =  findUser();
                  final group = Group(
                    groupName: groupNameController.text,
                    group_admins: [user.email!,],
                    group_users: []
                  );
                  createGroup(group);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GroupHomePage()),
                  );
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




  //create group method
  Future createGroup(Group group) async {
    final docGroup = FirebaseFirestore.instance.collection('groups').doc();
    group.id = docGroup.id;
    group.groupKey = generateGroupKey();


    final json = group.toJson();
    await docGroup.set(json);
  }

  // generates a random group key
  String generateGroupKey() {
    final length = 10;
    final letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final numbers = '0123456789';

    String chars = '';
    chars += '$letters$numbers';

    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);

      return chars[indexRandom];
    }).join('');
  }

  // Future<UserData?> findUser() async {
  //   final loggedUserEmail = FirebaseAuth.instance.currentUser!.email;
  //   final docUser =
  //       FirebaseFirestore.instance.collection('users').doc('JoCuxkiYkuHqNNptW6LG');
  //   final snapshot = await docUser.get();

  //   if (snapshot.exists) {
  //     return UserData.fromJson(snapshot.data()!);
  //   }
  // }

  // static UserData fromJson(Map<String, dynamic> json) => UserData(
  //   email: json['Email'],
  //   firstName: json['First Name'],
  //   lastName: json['Last Name'],
  //   );

}
