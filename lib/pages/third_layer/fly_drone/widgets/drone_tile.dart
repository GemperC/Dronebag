import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/drone_repository/drone_repository.dart';
import 'package:flutter/material.dart';
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
  List<Drone> selectedDrones = [];
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: selectedDrones.contains(widget.drone)
                ? Colors.blue
                : const Color.fromARGB(255, 65, 61, 82),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: ListTile(
            // go to the drone page
            // onTap: () {
            //   setState(() {
            //     pressed = !pressed;
            //     if (pressed) {
            //       droneList.add(widget.drone);
            //     } else {
            //       droneList.remove(widget.drone);
            //     }
            //   });
            // },
            // build the tile info and design
            title: Center(
          child: Padding(
            // padding betwwent he cards
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Container(
              decoration: BoxDecoration(
                  color: pressed
                      ? Colors.blue
                      : const Color.fromARGB(255, 65, 61, 82),

                  // color: Color.fromARGB(255, 65, 61, 82),
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
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
                  ],
                ),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
