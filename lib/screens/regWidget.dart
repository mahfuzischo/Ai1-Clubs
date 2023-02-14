// import 'package:ai1_clubs/screens/log_in.dart';
// import 'package:ai1_clubs/screens/registration.dart';
// import 'package:ai1_clubs/screens/registrationphn.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class regWidget extends StatefulWidget {
//   final snap;
//   final img;
//   final id;
//   const regWidget(
//       {Key? key, required this.snap, required this.img, required this.id})
//       : super(key: key);

//   @override
//   State<regWidget> createState() => _regWidgetState();
// }

// class _regWidgetState extends State<regWidget> {
//   bool isPresent = false;

//   String? xname = '';
//   String? xbatch = '';
//   String? xdept = '';
//   String? xmail = '';
//   final _emailController = TextEditingController();
//   final _unameController = TextEditingController();
//   final _passController = TextEditingController();
//   final _cpassController = TextEditingController();
//   final _deptController = TextEditingController();
//   final _batchController = TextEditingController();
//   String _pass = '';
//   String _uname = '';
//   String _cpass = '';
//   String _uemail = '';
//   String _dept = '';
//   String _batch = '';
//   bool _isPassVisible1 = true;
//   bool _isPassVisible2 = true;

// // Future<bool> getDetails(dynamic uId) async {
//   // var collection = FirebaseFirestore.instance.collection('students');
//   // var docSnapshot = await collection.doc(uId).get();

//   // if (docSnapshot.exists) {
//   //   isPresent = true;
//   //   Map<String, dynamic>? data = docSnapshot.data();

//   //   xname:
//   //   data?['userName'];
//   //   xemail:
//   //   data?['email'];
//   //   xbatch:
//   //   data?['batch'];
//   //   xdept:
//   //   data?['dept'];
//   // } else {
//   //   print("Error getting details");
//   //   isPresent = false;
//   // }
// //   xname = xname.toString();
// //   xmail = xmail.toString();
// //   xbatch = xbatch.toString();
// //   xdept = xdept.toString();
// //   return isPresent;
// // }
//   void ShowSnackBarText(String text) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(text),
//       ),
//     );
//   }

//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             AutofillGroup(
//               child: Column(children: [
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(30, 30, 10, 0),
//                   child: TextFormField(
//                     autofillHints: widget.snap.data()['userName'],
//                     controller: _unameController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Invalid input";
//                       } else if (value.length < 4) {
//                         return "name must be at least 4 characters";
//                       }
//                       return null;
//                     },
//                     onChanged: (value) => setState(() => this._uname = value),
//                     decoration: InputDecoration(
//                       hintText: 'example name',
//                       labelText: "Enter your name",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(30, 30, 10, 0),
//                   child: TextFormField(
//                     autofillHints: widget.snap.data()['dept'],
//                     controller: _deptController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Invalid input";
//                       }
//                       return null;
//                     },
//                     onChanged: (value) => setState(() => this._dept = value),
//                     decoration: InputDecoration(
//                       hintText: 'Department of... ',
//                       //labelText: "Enter batch",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(30, 30, 10, 0),
//                   child: TextFormField(
//                     autofillHints: widget.snap.data()['batch'],
//                     controller: _batchController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Invalid input";
//                       }
//                       return null;
//                     },
//                     onChanged: (value) => setState(() => this._batch = value),
//                     decoration: InputDecoration(
//                       hintText: 'Batch number',
//                       //labelText: "Enter batch",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(30, 30, 10, 0),
//                   child: TextFormField(
//                     autofillHints: widget.snap.data()['email'],
//                     validator: (value) {
//                       if (value != null) {
//                         final RegExp regex = RegExp(
//                             r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)| (\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
//                         if (!regex.hasMatch(value!)) {
//                           return 'Enter a valid email';
//                         } else
//                           return null;
//                       } else {
//                         return 'Enter a valid email';
//                       }
//                     },
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter your email',
//                       labelText: 'Email',
//                       prefixIcon: Icon(Icons.mail),
//                       suffixIcon: _emailController.text.isEmpty
//                           ? Container(
//                               width: 0,
//                             )
//                           : IconButton(
//                               icon: Icon(Icons.close),
//                               onPressed: () => _emailController.clear(),
//                             ),
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.emailAddress,
//                     textInputAction: TextInputAction.done,
//                   ),
//                 ),
//               ]),
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(30, 30, 10, 30),
//               child: TextFormField(
//                 controller: _passController,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Invalid input";
//                   } else if (value.length < 4) {
//                     return "Password must be at least 4 characters";
//                   }
//                   return null;
//                 },
//                 onChanged: (value) => setState(() => this._pass = value),
//                 decoration: InputDecoration(
//                   hintText: 'Enter your password',
//                   labelText: "Password",
//                   //errorText: 'Invalid password',
//                   suffixIcon: IconButton(
//                     icon: _isPassVisible1
//                         ? Icon(Icons.visibility_off)
//                         : Icon(Icons.visibility),
//                     onPressed: () => setState(
//                       (() => _isPassVisible1 = !_isPassVisible1),
//                     ),
//                   ),
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: _isPassVisible1,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(30, 0, 10, 30),
//               child: TextFormField(
//                 controller: _cpassController,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Invalid input";
//                   } else if (value.length < 4) {
//                     return "Password must be at least 4 characters";
//                   } else if (value != _pass) {
//                     return "Please enter same password";
//                   }
//                   return null;
//                 },
//                 onChanged: (value) => setState(() => this._cpass = value),
//                 decoration: InputDecoration(
//                   hintText: 'Enter password again',
//                   labelText: "Confirm Password",
//                   //errorText: 'Invalid password',
//                   suffixIcon: IconButton(
//                     icon: _isPassVisible2
//                         ? Icon(Icons.visibility_off)
//                         : Icon(Icons.visibility),
//                     onPressed: () => setState(
//                       (() => _isPassVisible2 = !_isPassVisible2),
//                     ),
//                   ),
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: _isPassVisible2,
//               ),
//             ),
//             ElevatedButton(
//               child: Text('Submit'),
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.purpleAccent, // Background color
//                 onPrimary: Colors.white70,

//                 //splashFactory: Colors.grey[200],
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30.0),
//                   side: BorderSide(color: Theme.of(context).primaryColor),
//                 ),
//               ),
//               onPressed: () async {
//                 _uemail = _emailController.text.trim();
//                 _pass = _passController.text.trim();
//                 _uname = _unameController.text;
//                 if (_formKey.currentState != null) {
//                   if (_formKey.currentState!.validate() != false) {
//                     FirebaseAuth _auth = FirebaseAuth.instance;
//                     FirebaseFirestore _firebaseFirestore =
//                         FirebaseFirestore.instance;
//                     // dynamic _userRef = FirebaseFirestore.instance
//                     //     .collection('Users')
//                     //     .doc();
//                     // dynamic _x = await _userRef.get();
//                     // if (!_x.exists) {
//                     try {
//                       UserCredential userCredential =
//                           await _auth.createUserWithEmailAndPassword(
//                         email: _uemail,
//                         password: _pass,
//                       );

//                       print(_uname);
//                       print(_uemail);
//                       print(_pass);

//                       User? _user = _auth.currentUser;
//                       String photoUrl = await uploadImg(widget.img);

//                       var _userMap = {
//                         'uid': _user!.uid,
//                         'userName': _uname,
//                         'email': _user.email,
//                         'batch': _batch,
//                         'dept': _dept,
//                         'student_id': widget.id,
//                         'photoURL': photoUrl == null
//                             ? 'https://i.stack.imgur.com/l60Hf.png'
//                             : photoUrl,
//                       };
//                       print({_userMap});

//                       await _firebaseFirestore
//                           .collection('Users')
//                           .doc(_user.uid)
//                           .set(_userMap);

//                       // print(_uname);
//                       // print(_uemail);
//                       // print(_pass);

//                       Navigator.pushAndRemoveUntil(context,
//                           MaterialPageRoute(builder: (BuildContext context) {
//                         return logIn();
//                       }), (r) {
//                         return false;
//                       });
//                     } on FirebaseAuthException catch (e) {
//                       if (e.code == 'user-not-found') {
//                         ShowSnackBarText('No user found for that email.');
//                       } else if (e.code == 'wrong-password') {
//                         ShowSnackBarText('Wrong password provided.');
//                       } else if (e.code == 'email-already-in-use') {
//                         ShowSnackBarText("Email already registerd!");
//                       }
//                     }
//                   }
//                 }
//               },
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             TextButton(
//                 child: Text('Register with phone number'),
//                 onPressed: () {
//                   Navigator.pushAndRemoveUntil(context,
//                       MaterialPageRoute(builder: (BuildContext context) {
//                     return registration_Phn();
//                   }), (r) {
//                     return false;
//                   });
//                 }),
//             SizedBox(
//               height: 20,
//             ),
//             TextButton(
//                 child: Text('Already have an account?'),
//                 onPressed: () {
//                   Navigator.pushAndRemoveUntil(context,
//                       MaterialPageRoute(builder: (BuildContext context) {
//                     return logIn();
//                   }), (r) {
//                     return false;
//                   });
//                 }),
//           ],
//         ));
//   }
// }
