import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  String _uemail = '';
  String _uname = '';

  FirebaseAuth _auth = FirebaseAuth.instance;

// FirebaseUser firebaseUser = firebaseuser.getInstance().getCurrentUser();

// final userid = user.uid;

//                   FirebaseFirestore _firebaseFirestore =
//                       FirebaseFirestore.instance;

//                    final    User? _user = _auth.currentUser;

//                       var _userMap = {
//                         'uid': _user!.uid,
//                         'userName': _uname,
//                         'email': _user.email,
//                       };

//                       dynamic _userRef = FirebaseFirestore.instance
//                       .collection('mailUsers')
//                       .doc(_uemail);

//                        dynamic _x = await _userRef.get();
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
