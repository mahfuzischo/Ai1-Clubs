import 'package:ai1_clubs/screens/registrationphn.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ai1_clubs/screens/log_in.dart';
import 'package:ai1_clubs/screens/registration.dart';
import 'package:ai1_clubs/LUCC/lucc_home.dart';

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              child: Row(children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LUCC_Home()));
                          print('Welcome to LUCC');
                        },
                        child: Text('LUCC',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ))),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.orange[300],
                    alignment: Alignment.center,
                    child: Container(
                      child: TextButton(
                          onPressed: () {
                            print('Welcome to LUCC');
                          },
                          child: Text('IEEE',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ))),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.red[300],
                    alignment: Alignment.center,
                    child: Container(
                      child: TextButton(
                          onPressed: () {
                            print('Welcome to LUCC');
                          },
                          child: Text('Orpheus',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ))),
                    ),
                  ),
                ),
              ]),
              padding: EdgeInsets.all(10.00),
              alignment: Alignment.center,
              color: Colors.greenAccent[200],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: Row(children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.green[600],
                    alignment: Alignment.center,
                    child: Container(
                      child: TextButton(
                          onPressed: () {
                            print('Welcome to LUCC');
                          },
                          child: Text('LUBC',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ))),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.pink[200],
                    alignment: Alignment.center,
                    child: Container(
                      child: TextButton(
                          onPressed: () {
                            print('Welcome to LUCC');
                          },
                          child: Text('CE Family',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ))),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.blue[300],
                    alignment: Alignment.center,
                    child: Container(
                      child: TextButton(
                          onPressed: () {
                            print('Welcome to LUCC');
                          },
                          child: Text('LUTC',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ))),
                    ),
                  ),
                ),
              ]),
              padding: EdgeInsets.all(10.00),
              alignment: Alignment.center,
              color: Colors.orange[400],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: Row(children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.red[300],
                    alignment: Alignment.center,
                    child: Container(
                      child: TextButton(
                          onPressed: () {
                            print('Welcome to LUCC');
                          },
                          child: Text('LUSC',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ))),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.yellow[300],
                    alignment: Alignment.center,
                    child: Container(
                      child: TextButton(
                          onPressed: () {
                            print('Welcome to LUCC');
                          },
                          child: Text('LUMUN',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ))),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.green[300],
                    alignment: Alignment.center,
                    child: Container(
                      child: TextButton(
                          onPressed: () {
                            print('Welcome to LUCC');
                          },
                          child: Text('LUPS',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ))),
                    ),
                  ),
                ),
              ]),
              padding: EdgeInsets.all(10.00),
              alignment: Alignment.center,
              color: Colors.blue[200],
            ),
          )
        ],
      ),
    );
  }
}
