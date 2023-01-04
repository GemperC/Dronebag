// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/group_members_repository/group_members_repository.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
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
                  "Join a Drone Bag",
                  style: GoogleFonts.poppins(
                    color: ThemeColors.whiteTextColor,
                    fontSize: FontSize.xxLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    "Please fill in the Drone Bag's key to continue",
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
                      StreamBuilder<List<Group>>(
                          stream: fetchGroups(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final groups = snapshot.data!;
                              List<String> groupKeysList = [];
                              for (var group in groups) {
                                groupKeysList.add(group.key);
                              }
                              return TextFormField(
                                controller: groupKeyController,
                                validator: (value) {
                                  if (groupKeyController.text.isEmpty) {
                                    return "This field can't be empty";
                                  } else if (!groupKeysList
                                      .contains(groupKeyController.text)) {
                                    return "Invalid key, No such Drone bag";
                                  }
                                  return null;
                                },
                                style: GoogleFonts.poppins(
                                  color: ThemeColors.whiteTextColor,
                                ),
                                keyboardType: TextInputType.name,
                                cursorColor: ThemeColors.primaryColor,
                                decoration: InputDecoration(
                                  fillColor: ThemeColors.textFieldBgColor,
                                  filled: true,
                                  labelText: "Drone bag's Key",
                                  labelStyle: GoogleFonts.poppins(
                                    color: ThemeColors.textFieldHintColor,
                                    fontSize: FontSize.medium,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              // print(snapshot.error);
                              return const Text(
                                'Something went wrong!',
                                style: TextStyle(color: Colors.white),
                              );
                            } else {
                              return const Text(
                                'Something went wrong!',
                                style: TextStyle(color: Colors.white),
                              );
                            }
                          }),
                      const SizedBox(height: 50),
                      MainButton2(
                        text: 'Join Drone bag',
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

  Stream<List<Group>> fetchGroups() {
    return FirebaseFirestore.instance.collection('groups').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Group.fromJson(doc.data())).toList());
  }

  Future addUserToGroup(String groupKey) async {
    final isValid = formKey.currentState!.validate();

    if (!isValid) {
      return;
    } else {
      // set the settings for the new user in the group

// add the user to the members collection of the group
      FirebaseFirestore.instance
          .collection('groups')
          .where("key", isEqualTo: groupKey)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) async {
          final group =
              FirebaseFirestore.instance.collection('groups').doc(doc.id);
          group.update({
            'users': FieldValue.arrayUnion([user.email!])
          });

          final docuserSettings = FirebaseFirestore.instance
              .collection('users')
              .doc(user.email)
              .collection('settings')
              .doc(doc.get('id'));
          final usersettings =
              UserSettings(
                group: doc.get('name'),
                notifications: false,
                id: docuserSettings.id, 
                role: 'member');
          final json = usersettings.toJson();
          await docuserSettings.set(json);

          final docGroupMember = FirebaseFirestore.instance
              .collection('groups')
              .doc(doc.id)
              .collection('members')
              .doc(user.email);
          final member = GroupMember(role: 'member', email: user.email!);
          final jsonMember = member.toJson();
          await docGroupMember.set(jsonMember);
        });
      });

      Utils.showSnackBarWithColor(
          'You have joined the Drone bag!', Colors.blue);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyGroupsPage()),
      );
    }
  }
}
