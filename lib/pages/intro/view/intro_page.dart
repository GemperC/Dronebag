
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/main.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroPage extends StatefulWidget {
  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  final introdate = GetStorage();

  void endIntroductionScreen(context) {
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => IsLoggedIn()),
    );
    introdate.write('displayed', true);
  }

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        image: Container(
          child: Icon(
            Icons.backpack,
            color: Color.fromARGB(255, 255, 255, 255),
            size: 160.0,
          ),
          margin: const EdgeInsets.only(top: 35, bottom: 10),
          width: 200.0,
          height: 200.0,
          decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
        ),
        titleWidget: Text(
          'Dronebag',
          style: GoogleFonts.poppins(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: FontSize.large48,
            fontWeight: FontWeight.w600,
          ),
        ),
        bodyWidget: Text(
          'Manage your drone fleet with a \ncustom made app',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: ThemeColors.whiteTextColor,
            fontSize: FontSize.xMedium,
          ),
        ),
        decoration: const PageDecoration(
          pageColor: ThemeColors.scaffoldBgColor,
        ),
      ),
      PageViewModel(
          image: Container(
            child: Image.asset('assets/images/drone.png'),
            margin: const EdgeInsets.only(top: 35, bottom: 10),
            width: 200.0,
            height: 200.0,
          ),
          titleWidget: Column(
            children: [
              SizedBox(height: 40),
              Text(
                'Dronebag',
                style: GoogleFonts.poppins(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: FontSize.xxLarge,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          bodyWidget: Text(
            'Manage your drone fleet with a \ncustom made app',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: ThemeColors.whiteTextColor,
              fontSize: FontSize.xMedium,
            ),
          ),
          // footer: Text(
          //   "Footer Text  here",
          //   style: TextStyle(
          //     color: ThemeColors.whiteTextColor,
          //     fontSize: FontSize.small,
          //     fontWeight: FontWeight.w400,
          //   ),
          // ),
          decoration: const PageDecoration(
            pageColor: ThemeColors.scaffoldBgColor,
          )),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        //globalBackgroundColor: Colors.blue,
        showBackButton: true,
        showSkipButton: false,
        showNextButton: true,
        next: Text(
          'Next',
          style: GoogleFonts.poppins(
            color: ThemeColors.whiteTextColor,
            fontSize: FontSize.xMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        back: Text(
          'Back',
          style: GoogleFonts.poppins(
            color: ThemeColors.whiteTextColor,
            fontSize: FontSize.xMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        done: Text(
          'Get Started!',
          style: GoogleFonts.poppins(
            color: ThemeColors.whiteTextColor,
            fontSize: FontSize.xMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        onDone: () {
          endIntroductionScreen(context);
        },
        pages: getPages(),
      ),
    );
  }
}
