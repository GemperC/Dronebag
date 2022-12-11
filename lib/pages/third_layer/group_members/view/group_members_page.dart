import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/group_members_repository/group_members_repository.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/domain/user_repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupMembers extends StatefulWidget {
  final Group group;
  const GroupMembers({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  State<GroupMembers> createState() => _GroupMembersState();
}

class _GroupMembersState extends State<GroupMembers> {
  final loggedUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Members List",
            style: GoogleFonts.poppins(
              color: ThemeColors.whiteTextColor,
              fontSize: FontSize.xxLarge,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: ThemeColors.scaffoldBgColor),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: StreamBuilder<List<GroupMember>>(
            stream: fetchGroupMembers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                bool loggedUserIsAdmin = false;
                final groupUsers = snapshot.data!;
                List<GroupMember> groupAdminsList = [];
                List<GroupMember> groupMembersList = [];
                for (var user in groupUsers) {
                    if (user.role == 'admin') {
                      if (loggedUser.email == user.email) {
                        loggedUserIsAdmin = true;
                      }
                      groupAdminsList.add(user);
                    } else {
                      groupMembersList.add(user);
                    }
                  }
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Admins:',
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                          fontSize: FontSize.xLarge,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: groupAdminsList.length,
                        itemBuilder: ((context, index) {
                          return buildGroupMemberTile(
                              groupAdminsList[index], loggedUserIsAdmin);
                        })),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Users:',
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                          fontSize: FontSize.xLarge,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: groupMembersList.length,
                        itemBuilder: ((context, index) {
                          return buildGroupMemberTile(
                              groupMembersList[index], loggedUserIsAdmin);
                        })),
                  ],
                );
              } else if (snapshot.hasError) {
                return SingleChildScrollView(
                  child: Text('Something went wrong! \n\n$snapshot',
                      style: const TextStyle(color: Colors.white)),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  Stream<List<GroupMember>> fetchGroupMembers() {
    return FirebaseFirestore.instance
        .collection('groups/${widget.group.id}/members')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GroupMember.fromJson(doc.data()))
            .toList());
  }

  Widget buildGroupMemberTile(GroupMember member, bool loggedUserIsAdmin) {
    final memberDoc = FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.group.id)
        .collection("members")
        .doc(member.email);
    // print(getMemberName(member));
    return ListTile(
        onTap: (() {
          if (loggedUserIsAdmin) {
            if (member.role == 'admin' && member.email != loggedUser.email) {
              memberDoc.update({'role': 'member'});
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(member.email)
                  .collection("settings")
                  .doc(widget.group.id)
                  .update({
                    "role": "member",
                    "notifications": "false"
                    });
            } else if (member.role == 'member') {
              memberDoc.update({'role': 'admin'});
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(member.email)
                  .collection("settings")
                  .doc(widget.group.id)
                  .update({"role": "admin"});
            }
          }
        }),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Container(
              width: 450,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 65, 61, 82),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: FutureBuilder<UserData?>(
                    future: getMemberName(member),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final user = snapshot.data!;
                        return Column(
                          children: [
                            Text(
                              user.fullName,
                              style: GoogleFonts.poppins(
                                color: ThemeColors.whiteTextColor,
                                fontSize: FontSize.large,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        );
                      }
                      return const CircularProgressIndicator();
                    }),
              ),
            ),
          ),
        ));
  }

  Future<UserData?> getMemberName(GroupMember member) async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(member.email);
    final snapshot = await userDoc.get();

    if (snapshot.exists) {
      return UserData.fromJson(snapshot.data()!);
    }
    return null;
  }

  Widget buildMemberTile(String user) {
    return ListTile(
        onTap: (() {}),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 80,
              width: 450,
              decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Center(
                child: Text(
                  user,
                  style: GoogleFonts.poppins(
                    color: ThemeColors.whiteTextColor,
                    fontSize: FontSize.xxLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
