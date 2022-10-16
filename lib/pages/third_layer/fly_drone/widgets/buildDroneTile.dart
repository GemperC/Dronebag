import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildDroneTile extends StatefulWidget {
  final Drone drone;
  const BuildDroneTile({
    Key? key,
    required this.drone,
  }) : super(key: key);

  @override
  State<BuildDroneTile> createState() => _BuildDroneTileState();
}

class _BuildDroneTileState extends State<BuildDroneTile> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        // go to the drone page
        onTap: () {
          setState(() {
            pressed = !pressed;
          });
        },
        // build the tile info and design
        title: Center(
          child: Padding(
            // padding betwwent he cards
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Container(
              decoration: BoxDecoration(
                  color: pressed ? Colors.blue: Color.fromARGB(255, 65, 61, 82),

                  // color: Color.fromARGB(255, 65, 61, 82),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Padding(
                // padding of the text in the cards
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    Align(
                      //alingemt of the titel
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.drone.name,
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
                        'Serial Number: ${widget.drone.serial_number}',
                        style: GoogleFonts.poppins(
                          color: ThemeColors.textFieldHintColor,
                          fontSize: FontSize.small,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    // Align(
                    //   //alingemt of the titel
                    //   alignment: Alignment.topLeft,
                    //   child: Text(
                    //     'Airtime is ${drone.flight_time} hours',
                    //     style: GoogleFonts.poppins(
                    //       color: ThemeColors.textFieldHintColor,
                    //       fontSize: FontSize.medium,
                    //       fontWeight: FontWeight.w400,
                    //     ),
                    //   ),
                    // ),
                    // Align(
                    //   //alingemt of the titel
                    //   alignment: Alignment.topLeft,
                    //   child: Text(
                    //     'Active issues ${drone.flight_time}',
                    //     style: GoogleFonts.poppins(
                    //       color: ThemeColors.textFieldHintColor,
                    //       fontSize: FontSize.medium,
                    //       fontWeight: FontWeight.w400,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
