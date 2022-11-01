import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/user_repository/src/models/models.dart';
import 'package:dronebag/pages/second_layer/create_group/create_group.dart';
import 'package:dronebag/pages/second_layer/join_group/join_group.dart';
import 'package:dronebag/pages/second_layer/main_page/widgets/getUserName.dart';
import 'package:dronebag/pages/second_layer/my_groups/my_groups.dart';
import 'package:dronebag/widgets/main_button_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final userDoc =
        FirebaseFirestore.instance.collection("users").doc(user.email!).get();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.scaffoldBgColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome!",
                style: GoogleFonts.poppins(
                  color: ThemeColors.whiteTextColor,
                  fontSize: FontSize.xxxLarge,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GetUserName(),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Text(
                  "What you would like to do?",
                  style: GoogleFonts.poppins(
                    color: ThemeColors.greyTextColor,
                    fontSize: FontSize.medium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 60),
              MainButton2(
                text: 'My Groups',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyGroupsPage()),
                  );
                },
              ),
              SizedBox(height: 20),
              MainButton2(
                text: 'Create Group',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateGroupPage()),
                  );
                },
              ),
              SizedBox(height: 20),
              MainButton2(
                text: 'Join Group',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JoinGroupPage()),
                  );
                },
              ),
              Spacer(),
              MainButton2(
                text: 'Sign Out',
                onPressed: () => FirebaseAuth.instance.signOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
