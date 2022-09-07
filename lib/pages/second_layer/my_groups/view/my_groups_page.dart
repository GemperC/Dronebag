import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/pages/second_layer/my_groups/widgets/get_groups.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
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
                  "Your Groups",
                  style: GoogleFonts.poppins(
                    color: ThemeColors.whiteTextColor,
                    fontSize: FontSize.xxLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 7),
                //   child: Text(
                //     "Please fill the form to continue",
                //     style: GoogleFonts.poppins(
                //       color: ThemeColors.greyTextColor,
                //       fontSize: FontSize.medium,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                // ),
                //SizedBox(height: 50),
                Expanded(child: GetGroups())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//het all the groups from firestore and convert them to group objects
Stream<List<Group>> readGroups() =>
    FirebaseFirestore.instance
    .collection('groups')
    .snapshots()
    .map((snapshot) => 
      snapshot.docs.map((doc) => Group.fromJson(doc.data())).toList());
      



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
