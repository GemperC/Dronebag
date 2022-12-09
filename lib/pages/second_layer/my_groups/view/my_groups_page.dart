import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/group_members_repository/group_members_repository.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/pages/third_layer/group_main/view/group_main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyGroupsPage extends StatefulWidget {
  const MyGroupsPage({Key? key}) : super(key: key);

  @override
  State<MyGroupsPage> createState() => _MyGroupsPageState();
}

class _MyGroupsPageState extends State<MyGroupsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Your current Groups",
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
            child: StreamBuilder<List<Group>>(
              stream: readMyGroups(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final groups = snapshot.data!;
                  return ListView(
                    children: groups.map(buildGroupTile).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Something went wrong! \n\n$snapshot',
                      style: const TextStyle(color: Colors.white));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
            )),
      ),
    );
  }

  //get the group that contain the user
  Stream<List<Group>> readMyGroups() {
    final user = FirebaseAuth.instance.currentUser!;
    return FirebaseFirestore.instance
        .collection('groups')
        .where('users', arrayContains: user.email!)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Group.fromJson(doc.data())).toList());
  }

//build the the group tile
  Widget buildGroupTile(Group group) => ListTile(
      // go to the group main page
      onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyGroupPage(group: group)),
          ),
      //build the tile info and design
      title: Center(
        child: Padding(
          // padding betwwent he cards
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Container(
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 65, 61, 82),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Padding(
              // padding of the text in the cards
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: Column(
                children: [
                  Align(
                    //alingemt of the titel
                    alignment: Alignment.topLeft,
                    child: Text(
                      group.name,
                      style: GoogleFonts.poppins(
                        color: ThemeColors.whiteTextColor,
                        fontSize: FontSize.xxLarge,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Align(
                    //alingemt of the titel
                    alignment: Alignment.topLeft,
                    child: StreamBuilder<List<GroupMember>>(
                        stream: FirebaseFirestore.instance
                            .collection('groups')
                            .doc(group.id)
                            .collection('members')
                            .snapshots()
                            .map((snapshot) => snapshot.docs
                                .map((doc) => GroupMember.fromJson(doc.data()))
                                .toList()),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final groupMemberList = snapshot.data!;
                            return Text(
                              '${groupMemberList.length} Members',
                              style: GoogleFonts.poppins(
                                color: ThemeColors.textFieldHintColor,
                                fontSize: FontSize.medium,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Something went wrong! \n\n$snapshot',
                                style: const TextStyle(color: Colors.white));
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
}
