import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/app.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/pages/third_layer/group_main/widgets/getGroupKey.dart';
import 'package:dronebag/pages/third_layer/group_main/widgets/getGroupName.dart';
import 'package:dronebag/widgets/main_button_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MyGroupPage extends StatefulWidget {
  final String groupID;
  const MyGroupPage({
    Key? key,
    required this.groupID,
  }) : super(key: key);

  @override
  State<MyGroupPage> createState() => _MyGroupPageState();
}

class _MyGroupPageState extends State<MyGroupPage> {
  final group = FirebaseFirestore.instance.collection('groups').doc();

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
              GetGroupInfo(groupID: widget.groupID),
              SizedBox(height: 80),
              Center(
                child: Text(
                  "Actions",
                  style: GoogleFonts.poppins(
                    color: ThemeColors.greyTextColor,
                    fontSize: FontSize.large,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 20),
              MainButton2(
                  text: 'Group Key',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Container(
                        height: 20,
                        width: 20,
                        child: AlertDialog(
                          title: Center(child: Text('Group Key')),
                          content: Container(
                            height: 40,
                            child: Center(
                              child: GetGroupKey(
                                groupID: widget.groupID,
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => {
                                      Clipboard.setData(ClipboardData(
                                              text: getGroupKey(readGroup())))
                                          .then((value) {
                                        Utils.showSnackBarWithColor(
                                            'Key has been copied', Colors.blue);
                                      })
                                    },
                                child: Text('Copy')),
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Back')),
                          ],
                        ),
                      ),
                    );
                  }),
              SizedBox(height: 20),
              MainButton2(text: 'Drones', onPressed: () {}),
              SizedBox(height: 20),
              MainButton2(text: 'Fly A Drone', onPressed: () {}),
              SizedBox(height: 20),
              MainButton2(text: 'Members', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }

    readGroup() async {
    final groupDoc = FirebaseFirestore.instance
        .collection('groups').doc(widget.groupID);
    final snapshot = await groupDoc.get();

    if (snapshot.exists) {
      return Group.fromJson(snapshot.data()!);
    }
  }

  String getGroupKey(Group group) => group.key;

}

