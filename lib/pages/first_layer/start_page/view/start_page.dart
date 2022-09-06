import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/pages/first_layer/auth/auth.dart';
import 'package:dronebag/pages/first_layer/login/login.dart';
import 'package:dronebag/widgets/main_button.dart';
import 'package:dronebag/widgets/main_button_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image(
          //   image: AssetImage('assets/images/bg.jpg'),
          //   height: MediaQuery.of(context).size.height,
          //   fit: BoxFit.fitHeight,
          // ),
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  ThemeColors.scaffoldBgColor,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Container(
                    child: Icon(
                      Icons.backpack,
                      color: Color.fromARGB(255, 255, 255, 255),
                      size: 160.0,
                    ),
                    margin: const EdgeInsets.only(top: 35, bottom: 10),
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(color:Colors.blue, shape:BoxShape.circle),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Dronebag',
                      style: GoogleFonts.poppins(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: FontSize.large48,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    'Manage your drone fleet with a \ncustom made app',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                      fontSize: FontSize.medium,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 30),
                    child: MainButton2(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => AuthPage(),
                        ),
                        result: false,
                      ),
                      text: 'Get Started',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  void toggle() => setState(() => isLogin = !isLogin);
}
