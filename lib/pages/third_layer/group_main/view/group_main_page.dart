// ignore_for_file: sized_box_for_whitespace, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/app.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:dronebag/pages/third_layer/fly_drone/fly_drone.dart';
import 'package:dronebag/pages/third_layer/group__drones/view/view.dart';
import 'package:dronebag/pages/third_layer/group_batteries/group_battries.dart';
import 'package:dronebag/pages/third_layer/group_members/view/view.dart';
import 'package:dronebag/pages/third_layer/group_settings/view/view.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MyGroupPage extends StatefulWidget {
  final Group group;
  const MyGroupPage({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  State<MyGroupPage> createState() => _MyGroupPageState();
}

class _MyGroupPageState extends State<MyGroupPage> {
  final loggedUser = FirebaseAuth.instance.currentUser!;
  String userRole = '';
  @override
  void initState() {
    checkUserAdminPriviledges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.scaffoldBgColor,
        actions: [
          //===============DEBUG BUTTON===================
          loggedUser.email! == "testadmin@gmail.com"
              ? Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () async {
                      QuerySnapshot collection = await FirebaseFirestore
                          .instance
                          .collection("groups")
                          .doc(widget.group.id)
                          .collection("battery_stations")
                          .get();
                      collection.docs.forEach((doc) {
                        doc.reference.update({"current_location": ""});
                      });
                    },
                    child: const Icon(
                      Icons.bug_report,
                      size: 26.0,
                    ),
                  ))
              : Container()
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  // displays the groups name as a title
                  child: Text(
                    widget.group.name,
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                      fontSize: FontSize.xxLarge,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 80),
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    groupKeyButton(
                      const AssetImage('assets/icons/key.png'),
                      'Key',
                    ),
                    groupMenuButton(
                      const AssetImage('assets/icons/group-users.png'),
                      'Members',
                      GroupMembers(group: widget.group),
                    ),
                    groupMenuButton(
                      const AssetImage('assets/icons/settings.png'),
                      'Settings',
                      GroupSettings(group: widget.group),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    groupMenuButton(
                      const AssetImage('assets/icons/car-battery.png'),
                      'Batteries',
                      GroupBatteryStations(group: widget.group, privileges: userRole),
                    ),
                    groupMenuButton(
                      const AssetImage('assets/icons/drone.png'),
                      'Drones',
                      GroupDrones(group: widget.group, privileges: userRole),
                    ),
                    groupMenuButton(
                      const AssetImage('assets/icons/remote.png'),
                      'Fly a Drone',
                      StartFlightPage(group: widget.group),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget groupMenuButton(icon, String text, goTowidget) {
    return Container(
      height: 140,
      width: 80,
      //decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: Column(
        children: [
          FloatingActionButton.large(
            heroTag: text,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => goTowidget),
              );
            },
            child: ImageIcon(
              icon,
              size: 50,
            ),
          ),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: ThemeColors.whiteTextColor,
              fontSize: FontSize.small,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Widget groupKeyButton(icon, String text) {
    return Container(
      height: 140,
      width: 80,
      child: Column(
        children: [
          FloatingActionButton.large(
            heroTag: text,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: ThemeColors.scaffoldBgColor,
                  title: Center(
                    child: Text(
                      'Drone bag\'s Key',
                      style: GoogleFonts.poppins(
                        color: ThemeColors.whiteTextColor,
                        fontSize: FontSize.large,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  content: Container(
                    height: 120,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          widget.group.key,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: FontSize.large,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Dont share this with people you don\'t trust!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: ThemeColors.greyTextColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Back')),
                    TextButton(
                        onPressed: () => {
                              Clipboard.setData(ClipboardData(
                                      text: widget.group.key.toString()))
                                  .then((value) {
                                Utils.showSnackBarWithColor(
                                    'The Key has been copied', Colors.blue);
                              }),
                              Navigator.pop(context)
                            },
                        child: const Text('Copy')),
                  ],
                ),
              );
            },
            child: ImageIcon(
              icon,
              size: 40,
            ),
          ),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: ThemeColors.whiteTextColor,
              fontSize: FontSize.small,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Future<String> checkUserAdminPriviledges() async {
    var userSettingsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(loggedUser.email)
        .collection('settings')
        .doc(widget.group.id)
        .get();

    if (userSettingsSnapshot.exists) {
      Map<String, dynamic> data = userSettingsSnapshot.data()!;
      String role = data['role'];
      setState(() {
        userRole = data['role'];
      });
      return role;
    } else {
      return "member";
    }
  }
}
