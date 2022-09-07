import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/pages/second_layer/my_groups/my_groups.dart';
import 'package:dronebag/widgets/main_button_2.dart';
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Lets create a group",
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                      fontSize: FontSize.xxLarge,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(
                      "Please fill the form to continue",
                      style: GoogleFonts.poppins(
                        color: ThemeColors.greyTextColor,
                        fontSize: FontSize.medium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: groupNameController,
                          validator: (value) {
                            if (groupNameController.text.isEmpty) {
                              return "This field can't be empty";
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
                            hintText: "Group Name",
                            hintStyle: GoogleFonts.poppins(
                              color: ThemeColors.textFieldHintColor,
                              fontSize: FontSize.medium,
                              fontWeight: FontWeight.w400,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        MainButton2(
                          text: 'Create Group',
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
          ),
        ));
  }

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );

  //create group method
  Future createGroup() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid)
      return;
    else {
      final docGroup = FirebaseFirestore.instance.collection('groups').doc();

      final group = Group(
          groupName: groupNameController.text.trim(),
          group_admins: [user.email!],
          group_users: [],
          id: docGroup.id,
          groupKey: generateGroupKey());

      final json = group.toJson();
      await docGroup.set(json);
      Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyGroupsPage()),
                            );
    }
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
