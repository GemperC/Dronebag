import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/pages/third_layer/group_main/view/group_main_page.dart';
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
    return FutureBuilder<Group?>(
      future: fetchGroup(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        final group = snapshot.data;
        return group == null
            ? CircularProgressIndicator()
            : ListView(
                children: [

                ]
              );
      },
    );
  }

  Widget buildGroup(Group group) => ListTile(
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
                group.users.first,
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

  Future<Group?> fetchGroup() async {
    final groupDoc =
        FirebaseFirestore.instance.collection('groups').doc(widget.groupID);
    final snapshot = await groupDoc.get();

    if (snapshot.exists) {
      return Group.fromJson(snapshot.data()!);
    }
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(

  //     appBar: AppBar(
  //       title: Text(

  //                   "Members in your Group",
  //                   style: GoogleFonts.poppins(
  //                     color: ThemeColors.whiteTextColor,
  //                     fontSize: FontSize.xxLarge,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),

  //       backgroundColor: ThemeColors.scaffoldBgColor),

  //     body: SafeArea(
  //       child: Padding(
  //           padding: const EdgeInsets.all(30),
  //           child: StreamBuilder<Group>(
  //             stream: readMyGroupsMembers(),
  //             builder: ((context, snapshot) {
  //               if (snapshot.hasData) {
  //                 final groups = snapshot.data!;

  //                 return ListView(
  //                   children: groups.map(buildGroupMembers).toList(),
  //                 );
  //               } else if (snapshot.hasError) {
  //                 return Text('Something went wrong! \n\n${snapshot}',
  //                     style: TextStyle(color: Colors.white));
  //               } else {
  //                 return Center(child: CircularProgressIndicator());
  //               }
  //             }),
  //           )),
  //     ),
  //   );
  // }

//   Stream<Group> readMyGroupsMembers() {
//     return FirebaseFirestore.instance
//         .collection('groups')
//         .doc(widget.groupID)
//         .snapshots();

//   }

// //build the widget thast shows the groups
//   Widget buildGroupMembers(Group group) => ListTile(
//       onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => MyGroupPage(groupID: group.id,)),
//           ),
//       title: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             height: 80,
//             width: 450,
//             decoration: BoxDecoration(
//               color: ThemeColors.primaryColor,
//                   borderRadius: BorderRadius.all(Radius.circular(20))
// ),
//             child: Center(
//               child: Text(
//                 group.name,
//                 style: GoogleFonts.poppins(
//                   color: ThemeColors.whiteTextColor,
//                   fontSize: FontSize.xxLarge,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ));
}
