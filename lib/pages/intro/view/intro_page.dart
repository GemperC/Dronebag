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
        image: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Image.asset(
            "assets/intro/icon_no_bg.png",
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
          'Dronebag is a custom-made app designed for drone enthusiasts. With Dronebag, you can easily create drone groups and add drones to them, making it easy to keep track of your drone fleet.',
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
        image: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Image.asset('assets/intro/drone_fleet.png'),
        ),
        titleWidget: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              'Manage Your Drone Fleet with Ease',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: FontSize.xxLarge,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        bodyWidget: Text(
          ' With Dronebag, you can easily create and manage drone groups, monitor battery cycles, and receive notifications when your drones are in the air.',
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
        image: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Image.asset(
            'assets/intro/man.png',
            color: Colors.white,
          ),
        ),
        titleWidget: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              'Simplify Your Drone Operations',
              style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: FontSize.xxLarge,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        bodyWidget: Text(
          'Dronebag makes it easy to keep track of your drones, batteries, and flights. With its user-friendly interface and advanced features, Dronebag simplifies your drone operations and makes flying safer and more efficient.',
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
        image: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Image.asset(
            'assets/intro/cut.png',
            color: Colors.white,
          ),
        ),
        titleWidget: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              'No more paper work!',
              style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: FontSize.xxLarge,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        bodyWidget: Text(
          'Drones are a lot of fun, but managing them can be a hassle. With Dronebag, you can focus on flying and let our app take care of the rest. Dronebag simplifies drone management, so you can spend more time enjoying the experience.',
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
