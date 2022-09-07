import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: ThemeColors.scaffoldBgColor,
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(30),
            child: StreamBuilder<List<Group>>(
              stream: readGroups(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final groups = snapshot.data!;

                  return ListView(
                    children: groups.map(buildGroup).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Something went wrong! \n\n${snapshot}',
                      style: TextStyle(color: Colors.white));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
            )

            // SingleChildScrollView(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [

            //       Text(
            //         "Your Groups",
            //         style: GoogleFonts.poppins(
            //           color: ThemeColors.whiteTextColor,
            //           fontSize: FontSize.xxLarge,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //       // Padding(
            //       //   padding: const EdgeInsets.only(top: 7),
            //       //   child: Text(
            //       //     "Please fill the form to continue",
            //       //     style: GoogleFonts.poppins(
            //       //       color: ThemeColors.greyTextColor,
            //       //       fontSize: FontSize.medium,
            //       //       fontWeight: FontWeight.w600,
            //       //     ),
            //       //   ),
            //       // ),
            //       //SizedBox(height: 50),
            //       Expanded(child: GetGroups())
            //     ],
            //   ),
            // ),
            ),
      ),
    );
  }
}

//het all the groups from firestore and convert them to group objects
Stream<List<Group>> readGroups() => FirebaseFirestore.instance
    .collection('groups')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Group.fromJson(doc.data())).toList());

//build the widget thast shows the groups
Widget buildGroup(Group group) => Text(
      group.name,
      style: TextStyle(color: Colors.white),
    );



//         return Scaffold(
//       appBar: AppBar(
//         title: Text('Dronebag - My Groups'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//            Expanded(child:GetGroups())
//           ],
//         ),
//       ),
//     );
//   }
// }
