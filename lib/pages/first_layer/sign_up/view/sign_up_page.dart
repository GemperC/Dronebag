// ignore_for_file: library_private_types_in_public_api

import 'package:dronebag/config/font_size.dart';
import 'package:dronebag/config/theme_colors.dart';
import 'package:dronebag/domain/user_repository/user_repository.dart';
import 'package:dronebag/main.dart';
import 'package:dronebag/widgets/main_button_2.dart';
import 'package:dronebag/widgets/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback onClickedSignIn;
  const SignUpPage({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmemailController = TextEditingController();
  // final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();

  final double sizedBoxHight = 16;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    confirmemailController.dispose();
    // phoneController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
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
                  "New here? Welcome!",
                  style: GoogleFonts.poppins(
                    color: ThemeColors.whiteTextColor,
                    fontSize: FontSize.xxLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    "Please fill the form to continue",
                    style: GoogleFonts.poppins(
                      color: ThemeColors.greyTextColor,
                      fontSize: FontSize.medium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      //Name Input Field
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (nameController.text.isEmpty) {
                            return "Please fill in your full name";
                          }
                          return null;
                        },
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                        ),
                        keyboardType: TextInputType.name,
                        cursorColor: ThemeColors.primaryColor,
                        decoration: InputDecoration(
                          fillColor: ThemeColors.textFieldBgColor,
                          filled: true,
                          labelText: "Full Name",
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
                      SizedBox(height: sizedBoxHight),

                      //E-mail Input Field
                      TextFormField(
                        controller: emailController,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter a valid email'
                                : null,
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                        ),
                        cursorColor: ThemeColors.primaryColor,
                        keyboardType: TextInputType.emailAddress,
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
                      SizedBox(height: sizedBoxHight),

                      //confirm E-mail Input Field
                      TextFormField(
                        controller: confirmemailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null &&
                                emailController.text !=
                                    confirmemailController.text
                            ? 'Emails do not match'
                            : null,
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                        ),
                        cursorColor: ThemeColors.primaryColor,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          fillColor: ThemeColors.textFieldBgColor,
                          filled: true,
                          labelText: "Confirm Email",
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
                      SizedBox(height: sizedBoxHight),

                      //Phone Input Field
                      // TextFormField(
                      //   controller: phoneController,
                      //   validator: (value) {
                      //     if (phoneController.text.length != 10) {
                      //       return "please enter your phone number";
                      //     }
                      //     return null;
                      //   },
                      //   style: GoogleFonts.poppins(
                      //     color: ThemeColors.whiteTextColor,
                      //   ),
                      //   cursorColor: ThemeColors.primaryColor,
                      //   keyboardType: TextInputType.phone,
                      //   decoration: InputDecoration(
                      //     fillColor: ThemeColors.textFieldBgColor,
                      //     filled: true,
                      //     labelText: "Phone number",
                      //     labelStyle: GoogleFonts.poppins(
                      //       color: ThemeColors.textFieldHintColor,
                      //       fontSize: FontSize.medium,
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //     border: const OutlineInputBorder(
                      //       borderSide: BorderSide.none,
                      //       borderRadius: BorderRadius.all(Radius.circular(18)),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: sizedBoxHight),

                      //Password Input Field
                      TextFormField(
                        controller: passwordController,
                        validator: (value) => value != null && value.length < 6
                            ? 'Password minimum length 6 charecters'
                            : null,
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
                      SizedBox(height: sizedBoxHight),

                      //Confirm Password Input Field
                      TextFormField(
                        controller: confirmpasswordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null &&
                                passwordController.text !=
                                    confirmpasswordController.text
                            ? 'Passwords do not match'
                            : null,
                        obscureText: true,
                        style: GoogleFonts.poppins(
                          color: ThemeColors.whiteTextColor,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: ThemeColors.primaryColor,
                        decoration: InputDecoration(
                          fillColor: ThemeColors.textFieldBgColor,
                          filled: true,
                          labelText: "Confrim Password",
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
                      const SizedBox(height: 50),

                      //Sign in button
                      MainButton2(
                        text: 'Sign Up',
                        onPressed: signUp,
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
                        text: "Already have an account? ",
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSignIn,
                            text: 'Sign In',
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

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final user = UserData(
        fullName: nameController.text.trim(),
        email: emailController.text.trim(),
        // phone: phoneController.text.trim(),
      );
      user.createUser(user);
    } on FirebaseAuthException catch (e) {
      // print(e);

      Utils.showSnackBar(e.message);
    }
    // Navigator.of(context) not working!
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
