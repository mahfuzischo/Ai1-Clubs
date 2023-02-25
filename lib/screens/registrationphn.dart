import 'package:ai1_clubs/screens/log_in.dart';
import 'package:ai1_clubs/screens/registration.dart';
import 'package:flutter/material.dart';
import 'package:ai1_clubs/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai1_clubs/screens/registration1.dart';

import 'package:google_fonts/google_fonts.dart';

class registration_Phn extends StatefulWidget {
  @override
  State<registration_Phn> createState() => _registration_PhnState();
}

class _registration_PhnState extends State<registration_Phn> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  String _phn = '';
  String cnt = "BD";
  String _otp = '';
  String _uname = '';

  String country_code = '+88';
  String verId = '';
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  int screenstate = 0;

  final bool resizeToAvoidBottomInset = false;

  final _pincontroller = TextEditingController();

  void ShowSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Future<void> registerPhone(String _phn) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phn,
      codeAutoRetrievalTimeout: (String verificationId) {
        ShowSnackBarText('Verification Timeout');
      },
      verificationCompleted: (PhoneAuthCredential credential) {
        ShowSnackBarText("Auth Completed!");
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return logIn();
        }), (r) {
          return false;
        });
      },
      codeSent: (dynamic verificationId, int? forceResendingToken) {
        ShowSnackBarText('OTP sent');
        print("Verification id: ");
        print(verId.toString());
        print("vrificationID: $verificationId");

        setState(() {
          verId = verificationId;
          screenstate = 1;
        });
        print("Registered" + _phn);
      },
      verificationFailed: (FirebaseAuthException error) {
        print(error.toString());
        ShowSnackBarText('Verification Failed!');
      },
      timeout: Duration(seconds: 120),
    );
  }

  Future<void> verifyOTP() async {
    print("ver id: $verId");
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: _otp);

    await _auth.signInWithCredential(credential);

    User? _user = FirebaseAuth.instance.currentUser;
    var _userMap = {
      'uid': _user!.uid,
      'userName': _uname,
      'phone': _user.phoneNumber,
    };
    print(_userMap);

    _firebaseFirestore
        .collection('phoneUsers')
        .doc(_user.phoneNumber)
        .set(_userMap);
    print("Registered  otp map " + _phn);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => home(),
      ),
    );

    /*print(verId.toString());
    await FirebaseAuth.instance
        .signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verId,
        smsCode: _otp,
      ),
    )
        .whenComplete(() {
      User? _user = FirebaseAuth.instance.currentUser;
      var userMap = {
        'uid': _user!.uid,
        'userName': _uname,
        'phone': _user.phoneNumber,
      };
      print(userMap);

      _firebaseFirestore
          .collection('phoneUsers')
          .doc(_user.phoneNumber)
          .set(userMap);
      print("Registered  otp" + _phn);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => logIn(),
        ),
      );
    });*/
  }

  @override
  void initState() {
    super.initState();

    _phoneController.addListener(() => (setState(() {})));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          setState(() {
            screenstate = 0;
          });
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            backgroundColor: Colors.purple[300],
            centerTitle: true,
            title: Text(
              'Registration',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
          ),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                screenstate == 0 ? RegState() : otpState(),
                GestureDetector(
                  onTap: () async {
                    _phn = _phoneController.text.trim();
                    if (screenstate == 0) {
                      if (_nameController.text.isEmpty) {
                        ShowSnackBarText("Username is still empty!");
                      } else if (_phoneController.text.isEmpty) {
                        ShowSnackBarText("Phone number is still empty!");
                      } else if (_nameController.text.length <= 3) {
                        ShowSnackBarText(
                            "Username must be at least 4 charecters");
                      } else {
                        dynamic _userRef = FirebaseFirestore.instance
                            .collection('phoneUsers')
                            .doc(_phn);
                        dynamic _x = await _userRef.get();

                        if (!_x.exists) {
                          String p = _phoneController.text;
                          String q = "+880" + p;

                          registerPhone(q);
                        } else {
                          ShowSnackBarText("Phone number is already registerd");
                        }
                      }
                    } else {
                      if (_otp.length == 6 || _pincontroller.text.length == 6) {
                        verifyOTP();
                      } else {
                        ShowSnackBarText("Enter OTP correctly!");
                      }
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    margin: EdgeInsets.only(bottom: 60 / 12),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                        child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          backgroundColor: Colors.purple[300],
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2),
                    )),
                  ),
                ),
              ]),
        ));
  }

  Widget RegState() {
    return Column(children: [
      Padding(
        padding: EdgeInsets.fromLTRB(30, 30, 10, 30),
        child: TextFormField(
          controller: _nameController,
          onChanged: (value) => setState(() => this._uname = value),
          decoration: InputDecoration(
            hintText: 'example name',
            labelText: "Enter your name",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
        ),
      ),
      IntlPhoneField(
        controller: _phoneController,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          border: OutlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
        initialCountryCode: cnt,
      ),
      SizedBox(
        height: 20,
      ),
      TextButton(
          child: Text('Register with Email'),
          onPressed: () {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return regScreenOne();
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
          })
    ]);
  }

  Widget otpState() {
    return Column(
      children: [
        SizedBox(
          height: 60,
        ),
        Text(
          "We just sent a code to",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          '+880' + _phoneController.text,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(30, 60, 10, 30),
            child: PinCodeFields(
              controller: _pincontroller,
              length: 6,
              onComplete: ((value) {
                setState() {
                  _otp = value;
                }
              }),
            )),
      ],
    );
  }
}
