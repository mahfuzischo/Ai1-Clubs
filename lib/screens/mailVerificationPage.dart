import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ai1_clubs/screens/log_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai1_clubs/screens/registration1.dart';

class mailVerfication extends StatefulWidget {
  final userMap;
  const mailVerfication({super.key, required this.userMap});

  @override
  State<mailVerfication> createState() => _mailVerficationState();
}

class _mailVerficationState extends State<mailVerfication> {
  bool isVerified = false;
  Timer? timer;
  bool resendEmail = false;

  void initState() {
    super.initState();
    isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isVerified) {
      sendVerificationLink();
      timer = Timer.periodic(Duration(seconds: 6), (timer) {
        checkEmailVerified();
      });
    }
  }

  Future sendVerificationLink() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        resendEmail = false;
      });

      await Future.delayed(Duration(seconds: 8));

      setState(() {
        resendEmail = true;
      });
    } catch (e) {
      ShowSnackBarText(e.toString());
    }
  }

  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isVerified) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(widget.userMap);
      timer?.cancel();
    }
  }

  void ShowSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => isVerified
      ? logIn()
      : Scaffold(
          appBar: AppBar(
            title: Text("Verify Email"),
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "A verification mail has been sent to your email. ",
                textAlign: TextAlign.center,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    if (resendEmail == true) {
                      sendVerificationLink();
                    }
                  },
                  label: Text(
                    "Resend Email",
                    style: TextStyle(fontSize: 25),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  icon: Icon(
                    Icons.email,
                    size: 35,
                  )),
              TextButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .delete();
                  FirebaseAuth.instance.currentUser?.delete();

                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return regScreenOne();
                  }), (r) {
                    return false;
                  });
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 25),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
              )
            ],
          ),
        );
}
