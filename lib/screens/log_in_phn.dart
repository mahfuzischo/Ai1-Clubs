// import 'package:ai1_clubs/screens/home.dart';
// import 'package:ai1_clubs/screens/forgot_pass.dart';
// import 'package:ai1_clubs/screens/registration.dart';
// import 'package:flutter/material.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

// class logIn extends StatefulWidget {
//   @override
//   State<logIn> createState() => _logInState();
// }

// class _logInState extends State<logIn> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.amber[300],
//         title: Text(
//           'Log in',
//           style: TextStyle(
//               fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
//         ),
//       ),
//       body: validForm(),
//     );
//   }
// }

// class validForm extends StatefulWidget {
//   @override
//   State<validForm> createState() => _validFormState();
// }

// class _validFormState extends State<validForm> {
//   final _phoneController = TextEditingController();

//   String _phn = '';
//   bool isPassVisible1 = true;
//   bool isPassVisible2 = true;

//   final _formKey = GlobalKey<FormState>();

//   void dispose() {
//     _phoneController.dispose();

//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();

//     _phoneController.addListener(() => (setState(() {})));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: SingleChildScrollView(
//         child: Column(children: [
//           Padding(
//             padding: EdgeInsets.fromLTRB(30, 30, 10, 0),
//             child: TextFormField(
//               validator: ((value) {
//                 if (value == null || value.isEmpty || !value.contains('0-9')) {
//                   return "Invalid input or email";
//                 }
//               }),
//               onChanged: (value) => setState(() => _phn = value),
//               controller: _phoneController,
//               decoration: InputDecoration(
//                 hintText: '+880 XXXXXXXXXX',
//                 labelText: 'Phone',
//                 prefixIcon: Icon(Icons.mail),
//                 suffixIcon: _phoneController.text.isEmpty
//                     ? Container(
//                         width: 0,
//                       )
//                     : IconButton(
//                         icon: Icon(Icons.close),
//                         onPressed: () => _phoneController.clear(),
//                       ),
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.phone,
//               textInputAction: TextInputAction.done,
//             ),
//           ),
//           ElevatedButton(
//             child: Text('Submit'),
//             style: ElevatedButton.styleFrom(
//               primary: Colors.amberAccent, // Background color
//               onPrimary: Colors.grey,

//               //splashFactory: Colors.grey[200],
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30.0),
//                 side: BorderSide(color: Theme.of(context).primaryColor),
//               ),
//             ),
//             onPressed: () async {
//               if (_formKey.currentState != null) {
//                 if (_formKey.currentState!.validate() != false) {
//                   // FocusScope.of(context).unfocus();

//                   final FirebaseAuth auth = FirebaseAuth.instance;
//                   _phn = _phoneController.text.trim();

//                   print(auth);

//                   /*  try {
//                     UserCredential userCredential =
//                         await FirebaseAuth.instance.verifyPhoneNumber(
//                             phoneNumber: _phn,
//                             verificationCompleted: (){},
//                             verificationFailed: (e) {
//                               Utils().toastMessage(e.toString());
//                             },
//                             codeSent: (String verificationId, int? forceResendingToken) {

//                               Navigator()
                              
//                             }),
//                             codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);

//                     var fbaseusr = userCredential.user;
//                     print(fbaseusr!.uid);
//                     if (fbaseusr.uid.isNotEmpty) {
//                       Navigator.of(context).push(
//                           MaterialPageRoute(builder: (context) => home()));
//                     } else {
//                       print("Invalid uid");
//                     }
//                   } on FirebaseAuthException catch (e) {
//                     print(e.toString());
//                     if (e.code == 'user-not-found') {
//                       print('No user found for that email.');
//                     } else if (e.code == 'wrong-password') {
//                       print('Wrong password provided.');
//                     }
//                   }*/
//                 } else {
//                   print("Validation failed");
//                 }
//               } else {
//                 print("Current user : Null");
//               }
//             },

//             // color: Colors.amberAccent,
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           TextButton(
//               child: Text('Create new account'),
//               onPressed: () {
//                 Navigator.pushAndRemoveUntil(context,
//                     MaterialPageRoute(builder: (BuildContext context) {
//                   return registration();
//                 }), (r) {
//                   return false;
//                 });
//               }),
//         ]),
//       ),
//     );
//   }
// }
