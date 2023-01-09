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

import 'package:google_fonts/google_fonts.dart';

class phone_reg extends StatefulWidget {
  @override
  State<phone_reg> createState() => _phone_regState();
}

class _phone_regState extends State<phone_reg> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _otpController = TextEditingController();
  String _phn = '';
  String cnt = "BD";
  String _otp = '';
  String _uname = '';

  String country_code = '+88';
  dynamic verId = '';
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
      verificationCompleted: (PhoneAuthCredential credential) async {
        ShowSnackBarText("Auth Completed!");
        await _auth.signInWithCredential(credential);

        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return logIn();
        }), (r) {
          return false;
        });
      },
      codeSent: (String verificationId, int? forceResendingToken) async {
        ShowSnackBarText('OTP sent');
        verId = verificationId;
        print(verId.toString());
        setState(() {
          otpState();
        });

        print("vrificationID: $verificationId");

        //String smscode = await get_otp();

        // Create a PhoneAuthCredential with the code

        print("Registered" + _phn);
      },
      verificationFailed: (FirebaseAuthException error) {
        print(error.toString());
        ShowSnackBarText('Verification Failed!');
      },
      timeout: Duration(seconds: 120),
    );
  }

  void verifyOtp(dynamic verID, dynamic otp) async {
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: otp);

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
        builder: (context) => logIn(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _phoneController.addListener(() => (setState(() {})));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(children: [
              Padding(
                padding: EdgeInsets.fromLTRB(30, 30, 10, 30),
                child: TextFormField(
                  controller: _nameController,
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
              /* Padding(
                padding: EdgeInsets.fromLTRB(30, 30, 10, 30),
                child: TextFormField(
                  controller: _otpController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Invalid input";
                    } else if (value.length < 6) {
                      return "OTP must be 6 digits";
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() => this._otp = value),
                  decoration: InputDecoration(
                    hintText: 'X X X X X X',
                    labelText: "Enter OTP",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                ),
              ),*/
              ElevatedButton(
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple[400], // Background color
                    onPrimary: Colors.white,

                    //splashFactory: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onPressed: () async {
                    if (screenstate == 0) {
                      if (_nameController.text.isEmpty) {
                        ShowSnackBarText("Username is still empty!");
                      } else if (_phoneController.text.isEmpty) {
                        ShowSnackBarText("Phone number is still empty!");
                      } else {
                        String p = _phoneController.text;
                        String q = "+880" + p;
                        //String p = _phoneController.text;
                        registerPhone(q);
                      }
                    } /*else {
                      _otp = _otpController.text;
                      if (_otp.length == 6) {
                        String get_otp() {
                          return _otp;
                        }
                      } else {
                        ShowSnackBarText("Enter OTP correctly!");
                      }
                    }*/
                  }),
              SizedBox(
                height: 20,
              ),
              TextButton(
                  child: Text('Register with Email'),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return registration();
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
            ]))));
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
        ElevatedButton(
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              primary: Colors.purple[400], // Background color
              onPrimary: Colors.white,

              //splashFactory: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            onPressed: () async {
              _otp = _pincontroller.text;
              verifyOtp(verId, _otp);
            })
      ],
    );
  }
}
