// ignore_for_file: file_names

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
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
  final loggedUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData?>(
      future: readUser(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data;

          return user == null
              ? const Text('No User Name')
              : Text(
                  user.fullName,
                  style: GoogleFonts.poppins(
                    color: ThemeColors.whiteTextColor,
                    fontSize: FontSize.xxLarge,
                    fontWeight: FontWeight.w600,
                  ),
                );
          
        }
        return const Text('data');
      }),
    );
  }
  
  Future<UserData?> readUser() async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(loggedUser.email);
    final snapshot = await userDoc.get();

    if (snapshot.exists) {
      return UserData.fromJson(snapshot.data()!);
    }
    return null;
  }
}
