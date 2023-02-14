// import 'package:ai1_clubs/screens/forgot_pass.dart';
// import 'package:ai1_clubs/screens/home.dart';

// import 'package:ai1_clubs/screens/registration.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

// class login extends StatefulWidget {
//   @override
//   State<login> createState() => _loginState();
// }

// class _loginState extends State<login> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       appBar: AppBar(
//           centerTitle: true,
//           backgroundColor: Colors.amber[300],
//           title: Text(
//             'Log in',
//             style: TextStyle(
//                 fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
//           ),
//           leading: IconButton(
//             icon: Icon(
//               Icons.home,
//               color: Colors.grey,
//             ),
//             onPressed: () {
//               Navigator.of(context)
//                   .push(MaterialPageRoute(builder: (context) => home()));
//               /*Navigator.pushAndRemoveUntil(context,
//                   MaterialPageRoute(builder: (BuildContext context) {
//                 return home();
//               }), (r) {
//                 return false;
//               });*/
//             },
//           )),
//       body: validForm(),
//     );
//   }
// }

// class validForm extends StatefulWidget {
//   @override
//   State<validForm> createState() => _validFormState();
// }

// class _validFormState extends State<validForm> {
//   final _emailController = TextEditingController();
//   final _passController = TextEditingController();
//   String pass = '';

//   String uemail = '';
//   bool isPassVisible1 = true;
//   bool isPassVisible2 = true;
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   void dispose() {
//     _emailController.dispose();
//     _passController.dispose();
//     super.dispose();
//   }

//   singin() async {
//     try {
//       uemail = _emailController.text.trim();
//       pass = _passController.text.trim();
//       UserCredential userCredential = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: uemail, password: pass);

//       var fbaseusr = userCredential.user;
//       print(fbaseusr!.uid);
//       if (fbaseusr.uid.isNotEmpty) {
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => home()));
//       } else {
//         print("Invalid uid");
//       }
//     } on FirebaseAuthException catch (e) {
//       print(e.toString());
//       if (e.code == 'user-not-found') {
//         print('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         print('Wrong password provided.');
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     _emailController.addListener(() => (setState(() {})));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(children: [
//         Padding(
//           padding: EdgeInsets.fromLTRB(30, 30, 10, 0),
//           child: TextFormField(
//             validator: ((value) {
//               if (value == null ||
//                   value.isEmpty ||
//                   !value.contains('@gmail.com')) {
//                 return "Invalid input or email";
//               }
//             }),
//             onChanged: (value) => setState(() => uemail = value),
//             controller: _emailController,
//             decoration: InputDecoration(
//               hintText: 'Enter your email',
//               labelText: 'Email',
//               prefixIcon: Icon(Icons.mail),
//               suffixIcon: _emailController.text.isEmpty
//                   ? Container(
//                       width: 0,
//                     )
//                   : IconButton(
//                       icon: Icon(Icons.close),
//                       onPressed: () => _emailController.clear(),
//                     ),
//               border: OutlineInputBorder(),
//             ),
//             keyboardType: TextInputType.emailAddress,
//             textInputAction: TextInputAction.done,
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.fromLTRB(30, 30, 10, 30),
//           child: TextFormField(
//             controller: _passController,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return "Invalid input";
//               } else if (value.length < 4) {
//                 return "Password must be at least 4 characters";
//               }
//             },
//             onChanged: (value) => setState(() => pass = value),
//             decoration: InputDecoration(
//               hintText: 'Enter your password',
//               labelText: "Password",
//               //errorText: 'Invalid password',
//               suffixIcon: IconButton(
//                 icon: isPassVisible1
//                     ? Icon(Icons.visibility_off)
//                     : Icon(Icons.visibility),
//                 onPressed: () => setState(
//                   (() => isPassVisible1 = !isPassVisible1),
//                 ),
//               ),
//               border: OutlineInputBorder(),
//             ),
//             obscureText: isPassVisible1,
//           ),
//         ),
//         ElevatedButton(
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
//             onPressed: () {
//               // FocusScope.of(context).unfocus();

//               print(uemail);
//               print(pass);
//               print(auth);

//               singin();

//               // color: Colors.amberAccent,
//             }),
//         SizedBox(
//           height: 20,
//         ),
//         TextButton(
//             onPressed: () {
//               Navigator.of(context)
//                   .push(MaterialPageRoute(builder: (context) => forgotPass()));
//             },
//             child: Text(
//               "Forgot Password?",
//               style: TextStyle(
//                 color: Colors.blueAccent,
//                 fontStyle: FontStyle.italic,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 2,
//               ),
//             )),
//         SizedBox(
//           height: 20,
//         ),
//         TextButton(
//             child: Text('Create new account'),
//             onPressed: () {
//               Navigator.pushAndRemoveUntil(context,
//                   MaterialPageRoute(builder: (BuildContext context) {
//                 return registration();
//               }), (r) {
//                 return false;
//               });
//             }),
//       ]),
//     );
//   }
// }
