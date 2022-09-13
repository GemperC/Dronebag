import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/domain/user_repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetUserName extends StatefulWidget {
  const GetUserName({Key? key}) : super(key: key);

  @override
  State<GetUserName> createState() => _GetUserNameState();
}

class _GetUserNameState extends State<GetUserName> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData?>(
      future: readUser(user.email!),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data;

          return user == null ? Text('No User') : buildUser(user);
        }
        return Text('data');
      }),
    );
  }

//het all the groups from firestore and convert them to group objects
  Future<UserData?> readUser(String userEmail) async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(userEmail);
    final snapshot = await userDoc.get();

    if (snapshot.exists) {
      return UserData.fromJson(snapshot.data()!);
    }
  }

//build the widget thast shows the groups
  Widget buildUser(UserData user) => Text(
        user.fullName,
        style: GoogleFonts.poppins(
          color: ThemeColors.whiteTextColor,
          fontSize: FontSize.xxLarge,
          fontWeight: FontWeight.w600,
        ),
      );
}
