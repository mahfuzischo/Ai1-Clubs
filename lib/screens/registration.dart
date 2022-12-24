import 'package:ai1_clubs/screens/log_in.dart';
import 'package:ai1_clubs/screens/log_in2.dart';
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
                if (value == null ||
                    value.isEmpty ||
                    !value.contains('@gmail')) {
                  return "Invalid input or email";
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
                  FirebaseAuth auth = FirebaseAuth.instance;
                  print(_uname);
                  print(_uemail);
                  print(_pass);
                  // User? user;

                  //   try {
                  UserCredential userCredential =
                      await auth.createUserWithEmailAndPassword(
                    email: _uemail,
                    password: _pass,
                  );
                  var usr = userCredential.user;

                  CollectionReference users =
                      FirebaseFirestore.instance.collection('mailUsers');

                  Future<void> addUser() {
                    // Call the user's CollectionReference to add a new user
                    return users
                        .add({
                          'Username': _uname, // John Doe
                          'Email': _uemail, // Stokes and Sons
                          'Pass': _pass // 42
                        })
                        .then((value) => print("User Added"))
                        .catchError(
                            (error) => print("Failed to add user: $error"));
                    try {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return logIn();
                      }), (r) {
                        return false;
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided.');
                      }
                    }
                  }

                  /*Future addUsers(
                        String Username, String Email, String Pass) async {
                      final docuser = await FirebaseFirestore.instance
                          .collection('mailUsers')
                          .doc('$Email');
                      final user = {
                        'Username': Username,
                        'Email': Email,
                        'Pass': Pass,
                      };
                    }

                    addUsers(_uname, _uemail, _pass);
*/

                  print(_uname);
                  print(_uemail);
                  print(_pass);
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
