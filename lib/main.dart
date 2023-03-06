import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_office/Constant/colors/constant_colors.dart';
import 'package:my_office/home/user_home_screen.dart';
import 'package:my_office/login/login_screen.dart';
import 'package:my_office/models/staff_model.dart';
import 'package:my_office/util/notification_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PR/invoice/image_saving/user_preference.dart';
import 'PR/invoice/provider_page.dart';
import 'introduction/intro_screen.dart';
import 'models/visit_model.dart';





/// version: 1.0.0+3 Updated On (21/02/2023)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserPreferences.init();

  //Hive database Setup
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(StaffModelAdapter().typeId)) {
    Hive.registerAdapter(StaffModelAdapter());
  }if (!Hive.isAdapterRegistered(VisitModelAdapter().typeId)) {
    Hive.registerAdapter(VisitModelAdapter());
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then(
    (value) => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    _notificationService.initializePlatformNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskData(),
      child: MaterialApp(
        title: 'My Office',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          primarySwatch: Colors.purple,
          scaffoldBackgroundColor: ConstantColor.backgroundColor,
          fontFamily: 'PoppinsRegular',
        ),
        home: const InitialScreen(),
      ),
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  InitialScreenState createState() => InitialScreenState();
}

class InitialScreenState extends State<InitialScreen>
    with AfterLayoutMixin<InitialScreen> {
  Future checkFirstSeen() async {
    final navigation = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);

    if (seen) {
      navigation.pushReplacement(MaterialPageRoute(
          builder: (context) => const AuthenticationScreen()));
    } else {
      await prefs.setBool('seen', true);
      navigation.pushReplacement(
          MaterialPageRoute(builder: (context) => const IntroductionScreen()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ConstantColor.blackColor,
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // print('iam inside of home ');
            // return const HomeScreen();
            return const UserHomeScreen();
          } else {
            // print('iam inside of login ');
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
