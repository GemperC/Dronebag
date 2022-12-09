import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
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
              const GetUserName(),
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
              const SizedBox(height: 60),
              MainButton2(
                text: 'My Drone bags',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyGroupsPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              MainButton2(
                text: 'Create a Drone bag',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateGroupPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              MainButton2(
                text: 'Join a Drone bag',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const JoinGroupPage()),
                  );
                },
              ),
              const Spacer(),
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
