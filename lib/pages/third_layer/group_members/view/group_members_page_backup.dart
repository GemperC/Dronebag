import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/domain/user_repository/src/models/models.dart';
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
  final StreamController<List<UserData>> _membersController =
      StreamController<List<UserData>>.broadcast();
  final loggedUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Group Members List",
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
          child:
              // StreamBuilder<List<UserData>>(
              //   stream: fetchGroupMembers(widget.group.users),
              //   builder: ((context, snapshot) {
              //     if (snapshot.hasData) {
              //       final groupMembersList = snapshot.data!;
              ListView.builder(
            itemCount: widget.group.users.length,
            itemBuilder: (context, index) {
              return buildMemberTile(widget.group.users[index]);
            },
          ),
        ),
      ),
    );
    // );
    // } else if (snapshot.hasError) {
    //   return Text('Something went wrong! \n\n${snapshot}',
    //       style: TextStyle(color: Colors.white));
    // } else {
    //   return Center(child: CircularProgressIndicator());
    // }
    // }),
    // )),
    // ),
    // );
  }

  // Stream<List<UserData>> fetchGroupMembers(List<dynamic> groupMembers) {
  //   Stream<List<UserData>> streamOfListUserData;
  //   List<UserData> userdata = [];
  //   groupMembers.forEach((member) {
  //     var data = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(member)
  //         .snapshots()
  //         .map((snapshot) =>
  //             UserData.fromJson(snapshot.data() as Map<String, dynamic>))
  //         .toList();
  //     _membersController.sink.add(data);
  //   });
  //   return _membersController.stream;
  // }

  Widget buildMemberTile(String user) {
    // if (widget.group.admins.contains(user.email)) {
    return ListTile(
        onTap: (() {
          // if (loggedUserIsAdmin && user.email != loggedUser.email) {
          //   final groupDoc = FirebaseFirestore.instance
          //       .collection('groups')
          //       .doc(widget.group.id);
          //   groupDoc.update({
          //     'Group_Admins': FieldValue.arrayRemove([user.email])
          //   });
          // }
        }),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 80,
              width: 450,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Center(
                child: Text(
                  "$user",
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
  // return ListTile(
  //     onTap: (() {
  //       if (loggedUserIsAdmin) {
  //         final groupDoc = FirebaseFirestore.instance
  //             .collection('groups')
  //             .doc(widget.group.id);
  //         groupDoc.update({
  //           'Group_Admins': FieldValue.arrayUnion([user.email])
  //         });
  //       }
  //     }),
  //     title: Center(
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Container(
  //           height: 80,
  //           width: 450,
  //           decoration: BoxDecoration(
  //               color: ThemeColors.primaryColor,
  //               borderRadius: BorderRadius.all(Radius.circular(20))),
  //           child: Center(
  //             child: Text(
  //               "${user.fullName} \n${user.email}",
  //               style: GoogleFonts.poppins(
  //                 color: ThemeColors.whiteTextColor,
  //                 fontSize: FontSize.xxLarge,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ));
}
  // Widget groupMember(
  //     String member, Group group, bool isAdmin, String loggedUserEmail) {
  //       lo
  //   return FutureBuilder<UserData?>(
  //     future: fetchUser(member),
  //     builder: ((context, snapshot) {
  //       if (snapshot.hasData) {
  //         final user = snapshot.data;

  //         return user == null
  //             ? CircularProgressIndicator()
  //             : buildMemberTile(user, group, isAdmin, loggedUserEmail);
  //       }
  //       return CircularProgressIndicator();
  //     }),
  //   );
  // }

  // Future<UserData?> fetchUser(String userEmail) async {
  //   final userDoc =
  //       FirebaseFirestore.instance.collection('users').doc(userEmail);
  //   final snapshot = await userDoc.get();

  //   if (snapshot.exists) {
  //     return UserData.fromJson(snapshot.data()!);
  //   }
  // }








/*
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/domain/user_repository/src/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupMembers extends StatefulWidget {
  final String groupID;
  const GroupMembers({
    Key? key,
    required this.groupID,
  }) : super(key: key);

  @override
  State<GroupMembers> createState() => _GroupMembersState();
}

class _GroupMembersState extends State<GroupMembers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Group Members List",
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
            child: FutureBuilder<Group?>(
              future: fetchGroup(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final group = snapshot.data!;
                  final loggedUser = FirebaseAuth.instance.currentUser!;
                  bool isAdmin = false;
                  if (group.admins.contains(loggedUser.email!)) isAdmin = true;

                  return ListView.builder(
                    itemCount: group.users.length,
                    itemBuilder: (context, index) {
                      final member = group.users[index];
                      return groupMember(member, group, isAdmin, loggedUser.email!);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Something went wrong! \n\n${snapshot}',
                      style: TextStyle(color: Colors.white));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
            )),
      ),
    );
  }

  Widget groupMember(String member, Group group, bool isAdmin, String loggedUserEmail) {
    return FutureBuilder<UserData?>(
      future: fetchUser(member),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data;

          return user == null
              ? CircularProgressIndicator()
              : buildMemberTile(user, group, isAdmin, loggedUserEmail);
        }
        return CircularProgressIndicator();
      }),
    );
  }

  Future<Group?> fetchGroup() async {
    final groupDoc =
        FirebaseFirestore.instance.collection('groups').doc(widget.groupID);
    final snapshot = await groupDoc.get();

    if (snapshot.exists) {
      return Group.fromJson(snapshot.data()!);
    }
  }

  Future<UserData?> fetchUser(String userEmail) async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(userEmail);
    final snapshot = await userDoc.get();

    if (snapshot.exists) {
      return UserData.fromJson(snapshot.data()!);
    }
  }

  Widget buildMemberTile(UserData user, Group group, bool isAdmin, String loggedUserEmail) {
    bool userTileIsAdmin = false;
    bool loggedUserIsAdmin = isAdmin;
    

    if (group.admins.contains(user.email)) {
      return ListTile(
          onTap: (() {
            if (loggedUserIsAdmin && user.email != loggedUserEmail) {
              final groupDoc = FirebaseFirestore.instance
                  .collection('groups')
                  .doc(widget.groupID);
              groupDoc.update({
                'Group_Admins': FieldValue.arrayRemove([user.email])
              });
            }
          }),
          title: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 80,
                width: 450,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Center(
                  child: Text(
                    "${user.fullName} \n${user.email}",
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
    return ListTile(
        onTap: (() {
          if (loggedUserIsAdmin) {
            final groupDoc = FirebaseFirestore.instance
                .collection('groups')
                .doc(widget.groupID);
            groupDoc.update({
              'Group_Admins': FieldValue.arrayUnion([user.email])
            });
          }
        }),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 80,
              width: 450,
              decoration: BoxDecoration(
                  color: ThemeColors.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Center(
                child: Text(
                  "${user.fullName} \n${user.email}",
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


*/