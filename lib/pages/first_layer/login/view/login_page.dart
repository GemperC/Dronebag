// ignore_for_file: library_private_types_in_public_api

import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/main.dart';
import 'package:dronebag/pages/first_layer/reset_password/reset_password.dart';
import 'package:dronebag/widgets/main_button_2.dart';
import 'package:dronebag/widgets/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const LoginPage({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let's get you in!",
                  style: GoogleFonts.poppins(
                    color: ThemeColors.whiteTextColor,
                    fontSize: FontSize.xxLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    "Login to your account",
                    style: GoogleFonts.poppins(
                      color: ThemeColors.greyTextColor,
                      fontSize: FontSize.medium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 70),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      ///Email Input Field
                      TextField(
                        controller: emailController,
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: ThemeColors.primaryColor,
                        decoration: InputDecoration(
                          fillColor: ThemeColors.textFieldBgColor,
                          filled: true,
                          labelText: "Email",
                          labelStyle: GoogleFonts.poppins(
                            color: ThemeColors.textFieldHintColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w400,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      ///Password Input Field
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: ThemeColors.primaryColor,
                        decoration: InputDecoration(
                          fillColor: ThemeColors.textFieldBgColor,
                          filled: true,
                          labelText: "Password",
                          labelStyle: GoogleFonts.poppins(
                            color: ThemeColors.textFieldHintColor,
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w400,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: GestureDetector(
                            child: Text(
                              "Forgot password?",
                              style: GoogleFonts.poppins(
                                color: ThemeColors.greyTextColor,
                                fontSize: FontSize.medium,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage(),
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(height: 90),
                      MainButton2(
                        text: 'Login',
                        onPressed: signIn,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.w600,
                        ),
                        text: "Don't have an account? ",
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSignUp,
                            text: 'Sign Up',
                            style: GoogleFonts.poppins(
                              color: ThemeColors.primaryColor,
                              fontSize: FontSize.medium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      //print(e);

      switch (e.code) {
        case 'user-not-found':
          Utils.showSnackBar('Invalid credentials');
          break;

        case 'unknown':
          Utils.showSnackBar('Please enter your email and password');
          break;

        case 'invalid-email':
          Utils.showSnackBar('Please enter a valid email address');
          break;

        case 'wrong-password':
          Utils.showSnackBar('Incorrect password');
          break;

        default:
          Utils.showSnackBar(e.message);
      }
    }
    // Navigator.of(context) not working!
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
