import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MainButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final String? iconPath;
  final Function() onTap;
  const MainButton({
    Key? key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    required this.onTap,
    this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 75,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor ?? ThemeColors.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconPath == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Image(
                        image: AssetImage(iconPath!),
                        height: 30,
                      ),
                    ),
              Text(
                text,
                style: GoogleFonts.poppins(
                  color: textColor ?? ThemeColors.whiteTextColor,
                  fontSize: FontSize.large,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}