import 'package:ai1_clubs/provider.dart';
import 'package:ai1_clubs/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai1_clubs/methods.dart';
import 'package:ai1_clubs/userData.dart';
import 'package:ai1_clubs/userData.dart' as model;
import 'package:provider/provider.dart';

class requestJoin extends StatefulWidget {
  const requestJoin({super.key});

  @override
  State<requestJoin> createState() => _requestJoinState();
}

class _requestJoinState extends State<requestJoin> {
  @override
  Widget build(BuildContext context) {
    provider _userProvider = Provider.of<provider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        centerTitle: true,
        title: Text(
          "LUCC Home",
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 300,
            ),
            Text("You are not a member of this club."),
            ElevatedButton(
                onPressed: () async {
                  String uid =
                      FirebaseAuth.instance.currentUser!.uid.toString();
                  await FirebaseFirestore.instance
                      .collection("requests")
                      .doc(uid)
                      .set({
                    'sid': _userProvider.getUser.student_id,
                    'name': _userProvider.getUser.userName,
                    'photoUrl': _userProvider.getUser.photoUrl,
                    'uid': _userProvider.getUser.uid
                  });
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return home();
                  }), (r) {
                    return false;
                  });
                },
                child: Text("Tap to register"))
          ],
        ),
      ),
    );
  }
}
//feb 26