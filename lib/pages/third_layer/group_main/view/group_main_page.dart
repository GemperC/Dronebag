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
  final String groupID;
  const MyGroupPage({
    Key? key,
    required this.groupID,
  }) : super(key: key);

  @override
  State<MyGroupPage> createState() => _MyGroupPageState();
}

class _MyGroupPageState extends State<MyGroupPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Group?>(
        future: fetchGroup(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final group = snapshot.data;

            return group == null
                ? CircularProgressIndicator()
                : Scaffold(
                    appBar: AppBar(
                      backgroundColor: ThemeColors.scaffoldBgColor,
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
                                  group.name,
                                  style: GoogleFonts.poppins(
                                    color: ThemeColors.whiteTextColor,
                                    fontSize: FontSize.xxLarge,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  groupKeyButton(
                                    AssetImage('assets/icons/key.png'),
                                    'Group Key',
                                    group,
                                  ),
                                  groupMenuButton(
                                    AssetImage('assets/icons/group-users.png'),
                                    'Members',
                                    GroupMembers(group: group),
                                  ),
                                  groupMenuButton(
                                    AssetImage('assets/icons/settings.png'),
                                    'Settings',
                                    GroupSettings(group: group),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  groupMenuButton(
                                    AssetImage('assets/icons/car-battery.png'),
                                    'Batteries',
                                    GroupBatteryStations(
                                        groupID: widget.groupID),
                                  ),
                                  groupMenuButton(
                                    AssetImage('assets/icons/drone.png'),
                                    'Drones',
                                    GroupDrones(groupID: widget.groupID),
                                  ),
                                  groupMenuButton(
                                    AssetImage('assets/icons/remote.png'),
                                    'Fly a Drone',
                                    StartFlightPage(group: group),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
          } else {
            return Scaffold();
          }
        });
  }

  Widget groupMenuButton(icon, String text, goTowidget) {
    return Container(
      height: 140,
      width: 80,
      //decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: Column(
        children: [
          FloatingActionButton.large(
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

  Widget groupKeyButton(icon, String text, Group group) {
    return Container(
      height: 140,
      width: 80,
      child: Column(
        children: [
          FloatingActionButton.large(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: ThemeColors.scaffoldBgColor,
                  title: Center(
                    child: Text(
                      'Group Key',
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
                        SizedBox(height: 20),
                        Text(
                          group.key,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: FontSize.large,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 30),
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
                        child: Text('Back')),
                    TextButton(
                        onPressed: () => {
                              Clipboard.setData(ClipboardData(
                                      text: group.key.toString()))
                                  .then((value) {
                                Utils.showSnackBarWithColor(
                                    'Key has been copied', Colors.blue);
                              }),
                              Navigator.pop(context)
                            },
                        child: Text('Copy')),
                    
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

  Future<Group?> fetchGroup() async {
    final groupDoc =
        FirebaseFirestore.instance.collection('groups').doc(widget.groupID);
    final snapshot = await groupDoc.get();

    if (snapshot.exists) {
      return Group.fromJson(snapshot.data()!);
    }
  }
}
