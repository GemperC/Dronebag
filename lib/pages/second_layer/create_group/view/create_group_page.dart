// ignore_for_file: body_might_complete_normally_nullable, use_build_context_synchronously

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/group_members_repository/group_members_repository.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/domain/user_settings_repository/user_settings_repository.dart';
import 'package:dronebag/pages/second_layer/my_groups/my_groups.dart';
import 'package:dronebag/widgets/main_button_2.dart';
import 'package:dronebag/widgets/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final groupNameController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

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
                  "Lets create a new Bag",
                  style: GoogleFonts.poppins(
                    color: ThemeColors.whiteTextColor,
                    fontSize: FontSize.xxLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    "Enter below the drone bag's name, \nWe will set up everything else",
                    style: GoogleFonts.poppins(
                      color: ThemeColors.greyTextColor,
                      fontSize: FontSize.medium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: groupNameController,
                        validator: (value) {
                          if (groupNameController.text.isEmpty) {
                            return "The drone bag's name cant be empty";
                          }
                        },
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                        ),
                        keyboardType: TextInputType.name,
                        cursorColor: ThemeColors.primaryColor,
                        decoration: InputDecoration(
                          fillColor: ThemeColors.textFieldBgColor,
                          filled: true,
                          labelText: "Drone bag Name",
                          labelStyle: GoogleFonts.poppins(
                            color: ThemeColors.textFieldHintColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w400,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      MainButton2(
                        text: 'Create New Bag',
                        onPressed: () {
                          createGroup();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  //create group method
  Future createGroup() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
//create the group
      final docGroup = FirebaseFirestore.instance.collection('groups').doc();
      final group = Group(
          name: groupNameController.text.trim(),
          id: docGroup.id,
          key: generateGroupKey(),
          users: [user.email!]);

      final jsonGroup = group.toJson();
      await docGroup.set(jsonGroup);

      //create the user settings for the group
      final docuserSettings = FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection('settings')
          .doc(docGroup.id);
      final usersettings = UserSettings(
        role: 'admin',
        id: docGroup.id,
        group: groupNameController.text.trim(),
      );
      final jsonUser = usersettings.toJson();
      await docuserSettings.set(jsonUser);

//add the user to the group members collection
      final docGroupMember = FirebaseFirestore.instance
          .collection('groups')
          .doc(docGroup.id)
          .collection('members')
          .doc(user.email);
      final member = GroupMember(role: 'admin', email: user.email!);
      final jsonMember = member.toJson();
      await docGroupMember.set(jsonMember);
      //show snackbar
      Utils.showSnackBarWithColor(
          'Drone bag "${groupNameController.text.trim()}" has been created',
          Colors.blue);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyGroupsPage()),
      );
    }
  }

  // generates a random group key
  String generateGroupKey() {
    const length = 10;
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';

    String chars = '';
    chars += '$letters$numbers';

    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);

      return chars[indexRandom];
    }).join('');
  }
}
