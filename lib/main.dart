import 'app.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(Dronebag());
}

final navigatorKey = GlobalKey<NavigatorState>();

class Dronebag extends StatelessWidget {
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        title: 'asdasdas',
        body: 'asdsadsa',
      )
    ];
  }

  const Dronebag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: ThemeColors.primaryColor,
        scaffoldBackgroundColor: ThemeColors.scaffoldBgColor,
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: Utils.messengerKey,
      home: IntroPage()
    );
  }
}

class IsLoggedIn extends StatelessWidget {
  const IsLoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Something went wrong!'));
          } else if (snapshot.hasData) {
            return HomePage(); //change to MainPage
          } else {
            return StartPage();
          }
        });
  }
}
