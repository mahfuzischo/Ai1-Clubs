import 'package:ai1_clubs/screens/log_in2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

class forgotPass extends StatefulWidget {
  @override
  State<forgotPass> createState() => _forgotPassState();
}

class _forgotPassState extends State<forgotPass> {
  String _uemail = '';
  final _emailController = TextEditingController();
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  Future passReset() async {
    _uemail = _emailController.text.trim();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _uemail);
      print("Done");
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 160,
              ),
              Text("Enter a new password to reset"),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 30, 10, 0),
                child: TextField(
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
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple[300], // Background color
                    onPrimary: Colors.grey[900],

                    //splashFactory: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  onPressed: () {
                    if (_emailController.text.isNotEmpty) {
                      print(_emailController.text.trim());
                      passReset();

                      // Navigator.of(context).push(
                      //  MaterialPageRoute(builder: (context) => login()));
                    } else {
                      print("Invalid input");
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(
                                "Please enter a valid email",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            );
                          });
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
