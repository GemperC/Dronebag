import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/domain/user_repository/src/models/models.dart';
import 'package:dronebag/domain/user_settings_repository/src/models/models.dart';
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
  bool? getNotificationsCheckBox = false;

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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(38),
            child: StreamBuilder<List<UserSettings>>(
                stream: fetchUserSettings(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final userSettings = snapshot.data!.first;
                    return userSettings == null
                        ? CircularProgressIndicator()
                        : Column(
                            children: [
                              // Align(
                              //   alignment: Alignment.topLeft,
                              //   child: Text(
                              //     "Lets start a Flight",
                              //     style: GoogleFonts.poppins(
                              //       color: ThemeColors.whiteTextColor,
                              //       fontSize: FontSize.xxLarge,
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              // ),
                              // Align(
                              //   alignment: Alignment.topLeft,
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(top: 7),
                              //     child: Text(
                              //       "But first fill the details below",
                              //       style: GoogleFonts.poppins(
                              //         color: ThemeColors.greyTextColor,
                              //         fontSize: FontSize.medium,
                              //         fontWeight: FontWeight.w600,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              SizedBox(height: 50),
                              Row(children: [
                                Text(
                                  'Get notifications from this group',
                                  style: GoogleFonts.poppins(
                                    color: ThemeColors.whiteTextColor,
                                    fontSize: FontSize.medium,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Theme(
                                  data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.grey),
                                  child: Checkbox(
                                    value: userSettings.notifications,
                                    onChanged: (value) {
                                      if (value!) {
                                        print(
                                            'sucsribed to ${widget.group.name}');

                                        FirebaseMessaging.instance
                                            .subscribeToTopic(
                                                widget.group.name);
                                      } else if (!value) {
                                        print(
                                            'unsucsribed from ${widget.group.name}');
                                        FirebaseMessaging.instance
                                            .unsubscribeFromTopic(
                                                widget.group.name);
                                      }
                                      setState(() {
                                        getNotificationsCheckBox = value;
                                      });
                                      final docSetting = FirebaseFirestore
                                          .instance
                                          .collection('users')
                                          .doc(loggedUser.email)
                                          .collection('settings')
                                          .doc(userSettings.id);
                                      docSetting
                                          .update({'notifications': value});
                                    },
                                  ),
                                ),
                              ])
                            ],
                          );
                  } else {
                    return Scaffold();
                  }
                }),
          ),
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

    // final userSettingsDoc =
    //     FirebaseFirestore.instance.collection('users').doc(loggedUser.email).collection("settings").where("group", isEqualTo: widget.group.name);
    // final snapshot = await userSettingsDoc.get();
    // if (snapshot.exists) {
    //   return UserData.fromJson(snapshot.data()!);
    // }
  }
}
