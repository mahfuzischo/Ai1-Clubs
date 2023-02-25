import 'package:ai1_clubs/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:ai1_clubs/provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  String _uemail = '';
  String _uname = '';

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    provider _userProvider = Provider.of<provider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            size: 30,
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () async {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return home();
            }), (r) {
              return false;
            });
          },
        ),
        elevation: 0,
        title: Text(
          'Profile',
        ),
        centerTitle: true,
      ),
      body: Container(
          color: Colors.white70,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: Column(mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        _userProvider.getUser.photoUrl,
                      ),
                      radius: 60,
                    ),
                    Divider(
                      height: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userProvider.getUser.userName,
                          style: TextStyle(
                            color: Colors.black38,
                            letterSpacing: 2.0,
                            fontSize: 15.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Student ID: " + _userProvider.getUser.student_id,
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 2.0,
                            fontSize: 15.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Department: " + _userProvider.getUser.dept,
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 2.0,
                            fontSize: 15.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Batch: " + _userProvider.getUser.batch,
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 2.0,
                            fontSize: 15.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "E-mail: " + _userProvider.getUser.email,
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 2.0,
                            fontSize: 15.0,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ]))),
    );
  }
}
