import 'package:ai1_clubs/screens/log_in.dart';
import 'package:ai1_clubs/screens/registration.dart';
import 'package:flutter/material.dart';
import 'package:ai1_clubs/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:google_fonts/google_fonts.dart';
/*
class registration_phn extends StatefulWidget {
  @override
  State<registration_phn> createState() => _registration_phnState();
}

class _registration_phnState extends State<registration_phn> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  double screenHeight = 0;
  double screenWidth = 0;
  double bottom = 0;

  String otpPin = " ";
  String countryDial = "+1";
  String verID = " ";

  int screenState = 0;

  Color blue = const Color(0xff8cccff);

  Future<void> verifyPhone(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 20),
      verificationCompleted: (PhoneAuthCredential credential) {
        showSnackBarText("Auth Completed!");
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnackBarText("Auth Failed!");
      },
      codeSent: (String verificationId, int? resendToken) {
        showSnackBarText("OTP Sent!");
        verID = verificationId;
        setState(() {
          screenState = 1;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        showSnackBarText("Timeout!");
      },
    );
  }

  Future<void> verifyOTP() async {
    await FirebaseAuth.instance
        .signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verID,
        smsCode: otpPin,
      ),
    )
        .whenComplete(() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => home(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bottom = MediaQuery.of(context).viewInsets.bottom;

    return WillPopScope(
      onWillPop: () {
        setState(() {
          screenState = 0;
        });
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: blue,
        body: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight / 8),
                  child: Column(
                    children: [
                      Text(
                        "JOIN US",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth / 8,
                        ),
                      ),
                      Text(
                        "Create an account today!",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: screenWidth / 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: circle(5),
              ),
              Transform.translate(
                offset: const Offset(30, -30),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: circle(4.5),
                ),
              ),
              Center(
                child: circle(3),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  height: bottom > 0 ? screenHeight : screenHeight / 2,
                  width: screenWidth,
                  color: Colors.white,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth / 12,
                      right: screenWidth / 12,
                      top: bottom > 0 ? screenHeight / 12 : 0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        screenState == 0 ? stateRegister() : stateOTP(),
                        GestureDetector(
                          onTap: () {
                            if (screenState == 0) {
                              if (usernameController.text.isEmpty) {
                                showSnackBarText("Username is still empty!");
                              } else if (phoneController.text.isEmpty) {
                                showSnackBarText(
                                    "Phone number is still empty!");
                              } else {
                                verifyPhone(countryDial + phoneController.text);
                              }
                            } else {
                              if (otpPin.length >= 6) {
                                verifyOTP();
                              } else {
                                showSnackBarText("Enter OTP correctly!");
                              }
                            }
                          },
                          child: Container(
                            height: 50,
                            width: screenWidth,
                            margin: EdgeInsets.only(bottom: screenHeight / 12),
                            decoration: BoxDecoration(
                              color: blue,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                "CONTINUE",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Widget stateRegister() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Username",
          style: GoogleFonts.montserrat(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: usernameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "Phone number",
          style: GoogleFonts.montserrat(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        IntlPhoneField(
          controller: phoneController,
          showCountryFlag: false,
          showDropdownIcon: false,
          initialValue: countryDial,
          onCountryChanged: (country) {
            setState(() {
              countryDial = "+" + country.dialCode;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget stateOTP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: "We just sent a code to ",
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: countryDial + phoneController.text,
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: "\nEnter the code here and we can continue!",
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        PinCodeFields(
            length: 6,
            controller: pinController,
            onComplete: (value) {
              setState(() {
                otpPin = value;
              });
            }),

        /* PinCodeTextField(
          controller: pinController,
          appContext: context,
          length: 6,
          onChanged: (value) {
            setState(() {
              otpPin = value;
            });
          },
          pinTheme: PinTheme(
            activeColor: blue,
            selectedColor: blue,
            inactiveColor: Colors.black26,
          ),
        ),*/
        const SizedBox(
          height: 20,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Didn't receive the code? ",
                style: GoogleFonts.montserrat(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      screenState = 0;
                    });
                  },
                  child: Text(
                    "Resend",
                    style: GoogleFonts.montserrat(
                      color: Colors.black87,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget circle(double size) {
    return Container(
      height: screenHeight / size,
      width: screenHeight / size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    );
  }
}
*/

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
      codeSent: (String verificationId, int? forceResendingToken) {
        ShowSnackBarText('OTP sent');
        verId = verificationId;
        setState(() {
          screenstate = 1;
        });
        print("Registered" + _phn);
      },
      verificationFailed: (FirebaseAuthException error) {
        ShowSnackBarText('Verification Failed!');
      },
      timeout: Duration(seconds: 120),
    );
  }

  Future<void> verifyOTP() async {
    await FirebaseAuth.instance
        .signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verId,
        smsCode: _otp,
      ),
    )
        .whenComplete(() {
      print("Registered  otp" + _phn);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => logIn(),
        ),
      );
    });
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
                  onTap: () {
                    if (screenstate == 0) {
                      if (_nameController.text.isEmpty) {
                        ShowSnackBarText("Username is still empty!");
                      } else if (_phoneController.text.isEmpty) {
                        ShowSnackBarText("Phone number is still empty!");
                      } else if (_nameController.text.length <= 3) {
                        ShowSnackBarText(
                            "Username must be at least 4 charecters");
                      } else {
                        String p = _phoneController.text;
                        String q = "+880" + p;
                        //String p = _phoneController.text;
                        registerPhone(q);
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
                          backgroundColor: Colors.purple,
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
      /* ElevatedButton(
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
                  /*  if (screenstate == 0) {
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
                    } else {
                      otpState();
                    }*/
                  }),*/
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
