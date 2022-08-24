import 'package:dronebag/providers/counter_provider.dart';
import 'package:dronebag/providers/shopping_cart_provider.dart';
import 'package:dronebag/screens/home_screen.dart';
import 'package:dronebag/screens/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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

class Dronebag extends StatelessWidget {
  const Dronebag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/second': (context) => SecondScreen(),
      },
    );
  }
}
