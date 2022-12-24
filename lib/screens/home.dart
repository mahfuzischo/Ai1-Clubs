import 'package:ai1_clubs/screens/registrationphn.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ai1_clubs/screens/log_in.dart';
import 'package:ai1_clubs/screens/registration.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  void ShowSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
            backgroundColor: Colors.amber[300],
            centerTitle: true,
            title: Text(
              'Home',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () async {
                  if (FirebaseAuth.instance.currentUser == null) {
                    ShowSnackBarText("Already logged out");
                  } else {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return logIn();
                    }), (r) {
                      return false;
                    });
                  }
                },
              )
            ]),
        body: Column(
          children: [
            Text("Home"),
            /*GridView.count(crossAxisCount: 3, mainAxisSpacing: 60, children: [
              Container(
                padding: EdgeInsets.all(10),
                height: 20,
                width: 20,
                child: Text("LU"),

                // color: Colors.deepPurple[200],
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/lulogo1.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ])*/
          ],
        ));
  }
}
