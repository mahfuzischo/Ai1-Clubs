import 'package:ai1_clubs/screens/log_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ai1_clubs/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';

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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: MyApp,
          builder: ((context, snapshot) {
            if (FirebaseAuth.instance.currentUser != null) {
              print('You have an error ${snapshot.error.toString()}');
              return home();
            } else if (FirebaseAuth.instance.currentUser == null) {
              return logIn();
            } else {
              return Text("Somthing went wrong");
            }
          }),
        ));
  }
}
