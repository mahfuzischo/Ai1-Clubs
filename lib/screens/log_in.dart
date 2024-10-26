import 'package:ai1_clubs/screens/home.dart';
import 'package:ai1_clubs/screens/forgot_pass.dart';
import 'package:ai1_clubs/screens/registration.dart';
import 'package:ai1_clubs/screens/registration1.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'mailVerificationPage.dart';

class logIn extends StatefulWidget {
  @override
  State<logIn> createState() => _logInState();
}

class _logInState extends State<logIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[600],
        title: Text(
          'Log in',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
      ),
      body: validForm(),
    );
  }
}

class validForm extends StatefulWidget {
  @override
  State<validForm> createState() => _validFormState();
}

class _validFormState extends State<validForm> {
  void ShowSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  String pass = '';

  String uemail = '';
  bool isPassVisible1 = true;
  bool isPassVisible2 = true;

  final _formKey = GlobalKey<FormState>();

  void dispose() {
    _emailController.dispose();
    _passController.dispose();
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
              validator: ((value) {
                if (value != null) {
                  final RegExp regex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

                  if (!regex.hasMatch(value!)) {
                    return 'Enter a valid email';
                  } else
                    return null;
                } else {
                  return 'Enter a valid email';
                }
              }),
              onChanged: (value) => setState(() => uemail = value),
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
              },
              onChanged: (value) => setState(() => pass = value),
              decoration: InputDecoration(
                hintText: 'Enter your password',
                labelText: "Password",
                //errorText: 'Invalid password',
                suffixIcon: IconButton(
                  icon: isPassVisible1
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                  onPressed: () => setState(
                    (() => isPassVisible1 = !isPassVisible1),
                  ),
                ),
                border: OutlineInputBorder(),
              ),
              obscureText: isPassVisible1,
            ),
          ),
          ElevatedButton(
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              primary: Colors.grey[600], // Background color
              onPrimary: Colors.grey[500],

              //splashFactory: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: BorderSide(color: Colors.grey),
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState != null) {
                if (_formKey.currentState!.validate() != false) {
                  // FocusScope.of(context).unfocus();

                  final FirebaseAuth auth = FirebaseAuth.instance;
                  uemail = _emailController.text.trim();
                  pass = _passController.text.trim();

                  print(uemail);
                  print(pass);
                  print(auth);

                  try {
                    uemail = _emailController.text.trim();
                    pass = _passController.text.trim();

                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: uemail, password: pass);
                    User? user = FirebaseAuth.instance.currentUser!;
                    bool isVerified = user.emailVerified;
                    if (isVerified == true) {
                      if (user.uid.isNotEmpty) {
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return home();
                        }), (r) {
                          return false;
                        });
                      } else {
                        print("Invalid uid");
                      }
                    } else {
                      ShowSnackBarText(
                          "Email is not verified. Please verify your email first.");
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Email not verified"),
                              content: Text(
                                  "Email is not verified. Please verify your email first."),
                              actions: <Widget>[
                                ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pushAndRemoveUntil(context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return mailVerfication(
                                          user: user.uid,
                                        );
                                      }), (r) {
                                        return false;
                                      }).then((value) =>
                                          Navigator.of(context).pop());
                                    },
                                    child: Text("Verify")),
                                ElevatedButton(
                                    onPressed: () async {
                                      FirebaseAuth.instance.signOut().then(
                                          (value) =>
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(builder:
                                                      (BuildContext context) {
                                                return logIn();
                                              }), (r) {
                                                return false;
                                              }));
                                    },
                                    child: Text("Cancel"))
                              ],
                            );
                            //Navigator.of(context).pop(context);
                          });
                    }

                    print(user!.uid);
                  } on FirebaseAuthException catch (e) {
                    print(e.toString());
                    if (e.code == 'user-not-found') {
                      ShowSnackBarText('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      ShowSnackBarText('Wrong password provided.');
                    }
                  }
                } else {
                  ShowSnackBarText("Validation failed");
                }
              } else {
                ShowSnackBarText("Current user : Null");
              }
            },

            // color: Colors.amberAccent,
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => forgotPass()));
              },
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              )),
          SizedBox(
            height: 20,
          ),
          TextButton(
              child: Text('Create new account'),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => regScreenOne()));
              }),
        ]),
      ),
    );
  }
}
