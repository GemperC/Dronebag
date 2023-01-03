import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:dronebag/domain/group_repository/group_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'drone_tile.dart';

class DroneSelectionDialog extends StatefulWidget {
  final Group group;

  const DroneSelectionDialog({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  State<DroneSelectionDialog> createState() => _DroneSelectionDialogState();
}

class _DroneSelectionDialogState extends State<DroneSelectionDialog> {
  List<Drone> selectedDrones = [];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ThemeColors.scaffoldBgColor,
      scrollable: true,
      title: Text(
        "Select Drones to fly",
        style: GoogleFonts.poppins(
          color: ThemeColors.whiteTextColor,
          fontSize: FontSize.large,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: StatefulBuilder(
        builder: ((context, setState) {
          return Container(
            height: 500,
            width: 300,
            child: StreamBuilder<List<Drone>>(
              stream: fetchGroupDrones(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final drones = snapshot.data!;
                  return Container(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: drones.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // return GestureDetector(
                        //   onTap: () {
                        //     setState(() {
                        //       // Toggle selected state of drone
                        //       if (selectedDrones.contains(drones[index])) {
                        //         selectedDrones.remove(drones[index]);
                        //         print('removed drone');
                        //       } else {
                        //         selectedDrones.add(drones[index]);
                        //         print('added drone');
                        //       }
                        //     });
                        //   },
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         color: selectedDrones.contains(drones[index])
                        //             ? Colors.blue
                        //             : const Color.fromARGB(255, 65, 61, 82),
                        //         borderRadius: const BorderRadius.all(
                        //             Radius.circular(12))),
                        return ListTile(
                          // go to the drone page
                          onTap: () {
                            setState(() {
                              // Toggle selected state of drone
                              if (selectedDrones.contains(drones[index])) {
                                selectedDrones.remove(drones[index]);
                                print('removed drone');
                              } else {
                                selectedDrones.add(drones[index]);
                                print('added drone');
                              }
                            });
                          },
                          // build the tile info and design
                          title: Center(
                            child: Padding(
                              // padding betwwent he cards
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: selectedDrones
                                            .contains(drones[index])
                                        ? Colors.blue
                                        : const Color.fromARGB(255, 65, 61, 82),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                child: Padding(
                                  // padding of the text in the cards
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Column(
                                    children: [
                                      Align(
                                        //alingemt of the titel
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          drones[index].name,
                                          style: GoogleFonts.poppins(
                                            color: ThemeColors.whiteTextColor,
                                            fontSize: FontSize.small,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        //alingemt of the titel
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Serial Number: ${drones[index].serial_number}',
                                          style: GoogleFonts.poppins(
                                            color:
                                                ThemeColors.textFieldHintColor,
                                            fontSize: FontSize.small,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SingleChildScrollView(
                    child: Text('Something went wrong! \n\n$snapshot',
                        style: const TextStyle(color: Colors.white)),
                  );
                } else {
                  return Container(
                      child: const Center(child: CircularProgressIndicator()));
                }
              }),
            ),
          );
        }),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(selectedDrones);
            },
            child: const Text('Done')),
      ],
    );
  }

  Stream<List<Drone>> fetchGroupDrones() {
    return FirebaseFirestore.instance
        .collection('groups/${widget.group.id}/drones')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Drone.fromJson(doc.data())).toList());
  }
}



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dronebag/config/font_size.dart';
// import 'package:dronebag/config/theme_colors.dart';
// import 'package:dronebag/domain/drone_repository/drone_repository.dart';
// import 'package:dronebag/domain/group_repository/group_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'drone_tile.dart';

// class DroneSelectionDialog extends StatefulWidget {
//   final Group group;

//   const DroneSelectionDialog({
//     Key? key,
//     required this.group,
//   }) : super(key: key);

//   @override
//   State<DroneSelectionDialog> createState() => _DroneSelectionDialogState();
// }

// class _DroneSelectionDialogState extends State<DroneSelectionDialog> {
//   List<Drone> selectedDrones = [];
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: ThemeColors.scaffoldBgColor,
//       scrollable: true,
//       title: Text(
//         "Select Drones to fly",
//         style: GoogleFonts.poppins(
//           color: ThemeColors.whiteTextColor,
//           fontSize: FontSize.large,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       content: StatefulBuilder(
//         builder: ((context, setState) {
//           return Container(
//             height: 500,
//             width: 300,
//             child: StreamBuilder<List<Drone>>(
//               stream: fetchGroupDrones(),
//               builder: ((context, snapshot) {
//                 if (snapshot.hasData) {
//                   final drones = snapshot.data!;
//                   return Container(
//                     child: ListView.builder(
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: drones.length,
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         return GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               // Toggle selected state of drone
//                               if (selectedDrones.contains(drones[index])) {
//                                 selectedDrones.remove(drones[index]);
//                                 print('removed drone');
//                               } else {
//                                 selectedDrones.add(drones[index]);
//                                 print('added drone');
//                               }
//                             });
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 color: selectedDrones.contains(drones[index])
//                                     ? Colors.blue
//                                     : const Color.fromARGB(255, 65, 61, 82),
//                                 borderRadius: const BorderRadius.all(
//                                     Radius.circular(12))),
//                             child: ListTile(
//                                 // go to the drone page
//                                 // onTap: () {
//                                 //   setState(() {
//                                 //     pressed = !pressed;
//                                 //     if (pressed) {
//                                 //       droneList.add(widget.drone);
//                                 //     } else {
//                                 //       droneList.remove(widget.drone);
//                                 //     }
//                                 //   });
//                                 // },
//                                 // build the tile info and design
//                                 title: Center(
//                               child: Padding(
//                                 // padding betwwent he cards
//                                 padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
//                                 child: Padding(
//                                   // padding of the text in the cards
//                                   padding:
//                                       const EdgeInsets.fromLTRB(20, 10, 20, 10),
//                                   child: Column(
//                                     children: [
//                                       Align(
//                                         //alingemt of the titel
//                                         alignment: Alignment.topLeft,
//                                         child: Text(
//                                           drones[index].name,
//                                           style: GoogleFonts.poppins(
//                                             color: ThemeColors.whiteTextColor,
//                                             fontSize: FontSize.small,
//                                             fontWeight: FontWeight.w400,
//                                           ),
//                                         ),
//                                       ),
//                                       Align(
//                                         //alingemt of the titel
//                                         alignment: Alignment.topLeft,
//                                         child: Text(
//                                           'Serial Number: ${drones[index].serial_number}',
//                                           style: GoogleFonts.poppins(
//                                             color:
//                                                 ThemeColors.textFieldHintColor,
//                                             fontSize: FontSize.small,
//                                             fontWeight: FontWeight.w400,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             )),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 } else if (snapshot.hasError) {
//                   return SingleChildScrollView(
//                     child: Text('Something went wrong! \n\n$snapshot',
//                         style: const TextStyle(color: Colors.white)),
//                   );
//                 } else {
//                   return Container(
//                       child: const Center(child: CircularProgressIndicator()));
//                 }
//               }),
//             ),
//           );
//         }),
//       ),
//       actions: [
//         TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('Cancel')),
//         TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(selectedDrones);
//             },
//             child: const Text('Done')),
//       ],
//     );
//   }

//   Stream<List<Drone>> fetchGroupDrones() {
//     return FirebaseFirestore.instance
//         .collection('groups/${widget.group.id}/drones')
//         .snapshots()
//         .map((snapshot) =>
//             snapshot.docs.map((doc) => Drone.fromJson(doc.data())).toList());
//   }
// }
