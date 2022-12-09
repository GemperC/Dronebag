import 'app.dart';

Future<void> backgroudHandler(RemoteMessage message) async {
  // print('this is message from backgroud');
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  FirebaseMessaging.onBackgroundMessage(backgroudHandler);
  runApp(const Dronebag());
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
        home: introdata.read('displayed') ? const IsLoggedIn() : const IntroPage());
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          } else if (snapshot.hasData) {
            return const MainPage(); //change to MainPage
          } else {
            return const AuthPage();
          }
        });
  }
}
