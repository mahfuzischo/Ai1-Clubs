import 'package:ai1_clubs/screens/log_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai1_clubs/screens/registration2.dart';
import 'package:ai1_clubs/screens/registration.dart';

class regScreenOne extends StatefulWidget {
  const regScreenOne({super.key});

  @override
  State<regScreenOne> createState() => _regScreen1State();
}

class _regScreen1State extends State<regScreenOne> {
  final _idController = TextEditingController();
  String _id = '';

  bool isValid = false;
  void ShowSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  void dispose() {
    super.dispose();
    _idController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<bool> getValid(String id) async {
    bool x;
    var collection = FirebaseFirestore.instance.collection('students');
    var docSnapshot = await collection.doc(id).get();
    if (docSnapshot.exists) {
      isValid = true;
      print("Valid student");
    } else {
      print("Student is invalid");
    }
    x = isValid;
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            size: 30,
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () async {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return logIn();
            }), (r) {
              return false;
            });
          },
        ),
        centerTitle: true,
        title: Text(
          'Registration',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(30, 30, 10, 0),
            child: TextFormField(
              controller: _idController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Invalid input";
                } else if (_id.length < 10) {
                  return "Invalid input length";
                }
                return null;
              },
              onChanged: (value) => setState(() => this._id = value),
              decoration: InputDecoration(
                hintText: 'Enter your Student ID',
                labelText: "ID",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 250,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orangeAccent[300],
                onPrimary: Colors.white70,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              onPressed: () async {
                bool isValid = await getValid(_idController.text.trim());
                if (isValid == true) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => regScreenTwo(
                            reqId: _idController.text.trim(),
                          )));
                } else {
                  ShowSnackBarText(
                      "Student ID is not registered in server. Please contact the authority");
                }
              },
              child: Center(
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 50,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
