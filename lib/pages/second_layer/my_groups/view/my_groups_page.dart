import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/pages/third_layer/group_main/view/group_main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  Stream<List<Group>> readMyGroups() {
    final user = FirebaseAuth.instance.currentUser!;
    return FirebaseFirestore.instance
        .collection('groups')
        .where('Group_Users', arrayContains: user.email!)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Group.fromJson(doc.data())).toList());
  }

//build the widget thast shows the groups
  Widget buildGroupTile(Group group) => ListTile(
      // go to the group main page
      onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyGroupPage(groupID: group.id)),
          ),
      //build the tile info and design
      title: Center(
        child: Padding(
          // padding betwwent he cards
          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 65, 61, 82),
                borderRadius: BorderRadius.all(Radius.circular(12))),
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
                    child: Text(
                      '${group.users.length} Members',
                      style: GoogleFonts.poppins(
                        color: ThemeColors.textFieldHintColor,
                        fontSize: FontSize.large,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          
                ],
              ),
            ),
          ),
        ),
      ));


      
}
