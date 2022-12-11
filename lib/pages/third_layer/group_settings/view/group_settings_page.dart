// ignore_for_file: unused_import

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/domain/user_repository/src/models/models.dart';
import 'package:dronebag/domain/user_settings_repository/src/models/models.dart';
import 'package:dronebag/widgets/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupSettings extends StatefulWidget {
  final Group group;
  const GroupSettings({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  State<GroupSettings> createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  final loggedUser = FirebaseAuth.instance.currentUser!;
  bool? getNotificationsCheckBox;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Group Settings",
              style: GoogleFonts.poppins(
                color: ThemeColors.whiteTextColor,
                fontSize: FontSize.xxLarge,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: ThemeColors.scaffoldBgColor),
        body: Padding(
          padding: const EdgeInsets.all(38),
          child: StreamBuilder<List<UserSettings>>(
              stream: fetchUserSettings(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userSettings = snapshot.data!.first;
                  
                  print(userSettings.group);
                  print(userSettings.role);
                  return Column(
                    children: [
                      const SizedBox(height: 50),
                      Row(children: [
                        Text(
                          'Get notifications',
                          style: GoogleFonts.poppins(
                            color: ThemeColors.whiteTextColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Theme(
                          data: Theme.of(context)
                              .copyWith(unselectedWidgetColor: Colors.grey),
                          child: Checkbox(
                            value: userSettings.notifications,
                            onChanged: (value) {
                              if (userSettings.role == "admin") {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(loggedUser.email)
                                    .collection('settings')
                                    .doc(userSettings.id)
                                    .update({'notifications': value});
                                if (value!) {
                                  // print('sucsribed to ${widget.group.name}');

                                  FirebaseMessaging.instance
                                      .subscribeToTopic(widget.group.id);
                                } else if (!value) {
                                  // print(
                                  //     'unsucsribed from ${widget.group.name}');

                                  FirebaseMessaging.instance
                                      .unsubscribeFromTopic(widget.group.id);
                                }
                              } else {
                                
                                Utils.showSnackBarWithColor(
                                    'Only Admins allowed to user this feature',
                                    Colors.red);
                              }
                            },
                          ),
                        ),
                      ]),
                      const SizedBox(height: 50),
                      Align(
                        alignment: Alignment.topLeft,
                        child: MaterialButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(loggedUser.email)
                                .collection('settings')
                                .doc(widget.group.id)
                                .delete();

                            final groupDoc = FirebaseFirestore.instance
                                .collection('groups')
                                .doc(widget.group.id);

                            groupDoc
                                .collection('members')
                                .doc(loggedUser.email)
                                .delete();

                            groupDoc.update({
                              'users':
                                  FieldValue.arrayRemove([loggedUser.email]),
                            });
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                            Utils.showSnackBarWithColor(
                                'You left the Drone Bag', Colors.red);
                          },
                          color: Colors.red,
                          textColor: Colors.yellow,
                          padding: const EdgeInsets.all(10.0),
                          splashColor: Colors.grey,
                          child: Text(
                            "Leave this Drone Bag",
                            style: GoogleFonts.poppins(
                              color: ThemeColors.whiteTextColor,
                              fontSize: FontSize.medium,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return const Scaffold();
                }
              }),
        ));
  }

  Stream<List<UserSettings>> fetchUserSettings() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(loggedUser.email)
        .collection("settings")
        .where("group", isEqualTo: widget.group.name)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserSettings.fromJson(doc.data()))
            .toList());
  }
}
