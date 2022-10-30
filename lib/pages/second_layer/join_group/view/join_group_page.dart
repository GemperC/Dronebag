import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/user_settings_repository/src/models/models.dart';
import 'package:dronebag/pages/second_layer/my_groups/my_groups.dart';
import 'package:dronebag/widgets/main_button_2.dart';
import 'package:dronebag/widgets/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JoinGroupPage extends StatefulWidget {
  const JoinGroupPage({Key? key}) : super(key: key);

  @override
  State<JoinGroupPage> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final groupKeyController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    groupKeyController.dispose();
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
                  "Join a group",
                  style: GoogleFonts.poppins(
                    color: ThemeColors.whiteTextColor,
                    fontSize: FontSize.xxLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    "Please fill in the group's key to continue",
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
                        controller: groupKeyController,
                        validator: (value) {
                          if (groupKeyController.text.isEmpty) {
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
                          hintText: "Group Key",
                          hintStyle: GoogleFonts.poppins(
                            color: ThemeColors.textFieldHintColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      MainButton2(
                        text: 'Join Group',
                        onPressed: () {
                          addUserToGroup(groupKeyController.text);
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

  Future addUserToGroup(String groupKey) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      FirebaseFirestore.instance
          .collection('groups')
          .where("Group_Key", isEqualTo: groupKey)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final group =
              FirebaseFirestore.instance.collection('groups').doc(doc.id);
          group.update({
            'Group_Users': FieldValue.arrayUnion([user.email!])
          });
        });
      });
      final docuserSettings = FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection('settings')
          .doc();
      final usersettings =
          UserSettings(id: docuserSettings.id, notifications: false);

      final json = usersettings.toJson();
      await docuserSettings.set(json);

      Utils.showSnackBarWithColor('You have joined the Group', Colors.blue);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyGroupsPage()),
      );
    }
  }
}
