import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyGroupsPage extends StatefulWidget {
  const MyGroupsPage({Key? key}) : super(key: key);

  @override
  State<MyGroupsPage> createState() => _MyGroupsPageState();
}

class _MyGroupsPageState extends State<MyGroupsPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.scaffoldBgColor,
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(30),
            child: StreamBuilder<List<Group>>(
              stream: readGroups(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final groups = snapshot.data!;

                  return ListView(
                    children: groups.map(buildGroup).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Something went wrong! \n\n${snapshot}',
                      style: TextStyle(color: Colors.white));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
            )),
      ),
    );
  }
}

//het all the groups from firestore and convert them to group objects
Stream<List<Group>> readGroups() {
  final user = FirebaseAuth.instance.currentUser!;
  return FirebaseFirestore.instance
    .collection('groups')
    .where('Group_Admins', arrayContains: user.email!)
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Group.fromJson(doc.data())).toList());}

//build the widget thast shows the groups
Widget buildGroup(Group group) => Text(
      group.name,
      style: TextStyle(color: Colors.white),
    );
