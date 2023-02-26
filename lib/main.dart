import 'package:ai1_clubs/screens/log_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ai1_clubs/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:ai1_clubs/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void ShowSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  final Future<FirebaseApp> MyApp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => provider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AnimatedSplashScreen(
              splashIconSize: 300,
              splash: CircleAvatar(
                  radius: 170, backgroundImage: AssetImage("images/logo.jpg")),
              backgroundColor: Color(0xFF263238),
              nextScreen: main()),
        ));
  }

  Widget main() {
    return FutureBuilder(
      future: MyApp,
      builder: ((context, snapshot) {
        if (FirebaseAuth.instance.currentUser != null) {
          print('You have an error ${snapshot.error.toString()}');
          return home();
        } else if (FirebaseAuth.instance.currentUser == null) {
          return logIn();
        } else {
          return Text("Something went wrong...");
        }
      }),
    );
  }
}
