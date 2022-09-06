import 'package:dronebag/pages/first_layer/login/login.dart';
import 'package:dronebag/pages/first_layer/sign_up/sign_up.dart';
import 'package:dronebag/screens/login_widget.dart';
import 'package:dronebag/screens/sighup_widget.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) =>
      isLogin ? LoginPage() : SignUpPage(onClickedSignIn: toggle);

      void toggle() => setState(() => isLogin = !isLogin);
}
