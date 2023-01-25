import 'package:ai1_clubs/screens/log_in.dart';
import 'package:ai1_clubs/screens/log_in2.dart';
import 'package:ai1_clubs/screens/phoneReg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:ai1_clubs/screens/home.dart';
import 'package:ai1_clubs/screens/registrationphn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class registration extends StatefulWidget {
  @override
  State<registration> createState() => _registrationState();
}

class _registrationState extends State<registration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        centerTitle: true,
        title: Text(
          'Registration',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
      ),
      body: validateFormRemail(),
    );
  }
}

class validateFormRemail extends StatefulWidget {
  @override
  State<validateFormRemail> createState() => _validateFormRemailState();
}

class _validateFormRemailState extends State<validateFormRemail> {
  final _emailController = TextEditingController();
  final _unameController = TextEditingController();
  final _passController = TextEditingController();
  void ShowSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  String _pass = '';
  String _uname = '';
  String _cpass = '';
  String _uemail = '';

  bool _isPassVisible1 = true;
  bool _isPassVisible2 = true;
  final _formKey = GlobalKey<FormState>();

  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _unameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() => (setState(() {})));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.fromLTRB(30, 30, 10, 0),
            child: TextFormField(
              controller: _unameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Invalid input";
                } else if (value.length < 4) {
                  return "name must be at least 4 characters";
                }
                return null;
              },
              onChanged: (value) => setState(() => this._uname = value),
              decoration: InputDecoration(
                hintText: 'example name',
                labelText: "Enter your name",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 30, 10, 0),
            child: TextFormField(
              validator: (value) {
                if (value != null) {
                  final RegExp regex = RegExp(
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)| (\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                  if (!regex.hasMatch(value!)) {
                    return 'Enter a valid email';
                  } else
                    return null;
                } else {
                  return 'Enter a valid email';
                }
              },
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                labelText: 'Email',
                prefixIcon: Icon(Icons.mail),
                suffixIcon: _emailController.text.isEmpty
                    ? Container(
                        width: 0,
                      )
                    : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => _emailController.clear(),
                      ),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 30, 10, 30),
            child: TextFormField(
              controller: _passController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Invalid input";
                } else if (value.length < 4) {
                  return "Password must be at least 4 characters";
                }
                return null;
              },
              onChanged: (value) => setState(() => this._pass = value),
              decoration: InputDecoration(
                hintText: 'Enter your password',
                labelText: "Password",
                //errorText: 'Invalid password',
                suffixIcon: IconButton(
                  icon: _isPassVisible1
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                  onPressed: () => setState(
                    (() => _isPassVisible1 = !_isPassVisible1),
                  ),
                ),
                border: OutlineInputBorder(),
              ),
              obscureText: _isPassVisible1,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 10, 30),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Invalid input";
                } else if (value.length < 4) {
                  return "Password must be at least 4 characters";
                } else if (value != _pass) {
                  return "Please enter same password";
                }
                return null;
              },
              onChanged: (value) => setState(() => this._cpass = value),
              decoration: InputDecoration(
                hintText: 'Enter password again',
                labelText: "Confirm Password",
                //errorText: 'Invalid password',
                suffixIcon: IconButton(
                  icon: _isPassVisible2
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                  onPressed: () => setState(
                    (() => _isPassVisible2 = !_isPassVisible2),
                  ),
                ),
                border: OutlineInputBorder(),
              ),
              obscureText: _isPassVisible2,
            ),
          ),
          ElevatedButton(
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              primary: Colors.purpleAccent, // Background color
              onPrimary: Colors.white70,

              //splashFactory: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            onPressed: () async {
              _uemail = _emailController.text.trim();
              _pass = _passController.text.trim();
              _uname = _unameController.text;
              if (_formKey.currentState != null) {
                if (_formKey.currentState!.validate() != false) {
                  FirebaseAuth _auth = FirebaseAuth.instance;
                  FirebaseFirestore _firebaseFirestore =
                      FirebaseFirestore.instance;
                  dynamic _userRef = FirebaseFirestore.instance
                      .collection('mailUsers')
                      .doc(_uemail);
                  dynamic _x = await _userRef.get();
                  if (!_x.exists) {
                    try {
                      UserCredential userCredential =
                          await _auth.createUserWithEmailAndPassword(
                        email: _uemail,
                        password: _pass,
                      );

                      print(_uname);
                      print(_uemail);
                      print(_pass);

                      User? _user = _auth.currentUser;

                      var _userMap = {
                        'uid': _user!.uid,
                        'userName': _uname,
                        'email': _user.email,
                      };
                      print(_userMap);

                      await _firebaseFirestore
                          .collection('mailUsers')
                          .doc(_user.email)
                          .set(_userMap);

                      print(_uname);
                      print(_uemail);
                      print(_pass);

                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return logIn();
                      }), (r) {
                        return false;
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        ShowSnackBarText('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        ShowSnackBarText('Wrong password provided.');
                      } else if (e.code == 'email-already-in-use') {
                        ShowSnackBarText("Email already registerd!");
                      }
                    }
                  } else {
                    ShowSnackBarText("Email already registered!");
                  }
                }
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
              child: Text('Register with phone number'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return registration_Phn();
                }), (r) {
                  return false;
                });
              }),
          SizedBox(
            height: 20,
          ),
          TextButton(
              child: Text('Already have an account?'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return logIn();
                }), (r) {
                  return false;
                });
              }),
        ]),
      ),
    );
  }
}
