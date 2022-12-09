
import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/main.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  final introdate = GetStorage();

  void endIntroductionScreen(context) {
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const IsLoggedIn()),
    );
    introdate.write('displayed', true); //change to true in deployment
  }

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        image: Container(
          margin: const EdgeInsets.only(top: 35, bottom: 10),
          width: 200.0,
          height: 200.0,
          decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
          child: const Icon(
            Icons.backpack,
            color: Color.fromARGB(255, 255, 255, 255),
            size: 160.0,
          ),
        ),
        titleWidget: Text(
          'Dronebag',
          style: GoogleFonts.poppins(
            color: const Color.fromARGB(255, 255, 255, 255),
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
            margin: const EdgeInsets.only(top: 35, bottom: 10),
            width: 200.0,
            height: 200.0,
            child: Image.asset('assets/images/drone.png'),
          ),
          titleWidget: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                'Dronebag',
                style: GoogleFonts.poppins(
                  color: const Color.fromARGB(255, 255, 255, 255),
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
