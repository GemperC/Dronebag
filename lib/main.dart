import 'app.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  runApp(Dronebag());
}

final navigatorKey = GlobalKey<NavigatorState>();

class Dronebag extends StatefulWidget {
  const Dronebag({Key? key}) : super(key: key);

  @override
  State<Dronebag> createState() => _DronebagState();
}

class _DronebagState extends State<Dronebag> {
  final introdata = GetStorage();

  @override
  void initState() {
    super.initState();

    introdata.writeIfNull('displayed', false);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
          primaryColor: ThemeColors.primaryColor,
          scaffoldBackgroundColor: ThemeColors.scaffoldBgColor,
        ),
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: Utils.messengerKey,
        home: introdata.read('displayed') ? IsLoggedIn() : IntroPage()
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
            return LoginPage();
          }
        });
  }
}
