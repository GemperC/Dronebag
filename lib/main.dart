import 'package:dronebag/providers/counter_provider.dart';
import 'package:dronebag/providers/shopping_cart_provider.dart';
import 'package:dronebag/screens/home_screen.dart';
import 'package:dronebag/screens/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dronebag/screens/auth_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
        ChangeNotifierProvider(create: (_) => ShoppingCart()),
      ],
      child: Dronebag(),
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class Dronebag extends StatelessWidget {
  const Dronebag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,

      initialRoute: '/',
      routes: {
        '/': (context) => AuthScreen(),
        '/homescreen': (context) => HomePage(),
      },
    );
  }
}
