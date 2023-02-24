import 'package:ai1_clubs/methods.dart';
import 'package:ai1_clubs/screens/log_in.dart';
import 'package:ai1_clubs/screens/phoneReg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ai1_clubs/screens/registrationphn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:ai1_clubs/studentData.dart';
import 'package:logger/logger.dart';
import 'package:ai1_clubs/screens/mailVerificationPage.dart';

class regScreenTwo extends StatefulWidget {
  final reqId;
  const regScreenTwo({
    Key? key,
    required this.reqId,
  }) : super(key: key);

  @override
  State<regScreenTwo> createState() => _regScreenTwoState();
}

final imagePicker = ImagePicker();
final FirebaseFirestore fire = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;
File? img;

Future<String> uploadImg(File file) async {
  String _picname = const Uuid().v1();
  Reference ref = _storage
      .ref()
      .child("profiles")
      .child(_auth.currentUser!.uid)
      .child(_picname);
  UploadTask uploadTask = ref.putFile(file);
  TaskSnapshot snap = await uploadTask;
  String dldURL = await snap.ref.getDownloadURL();
  print("photourl:" + dldURL);
  return dldURL;
}

class _regScreenTwoState extends State<regScreenTwo> {
  void ShowSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Text(text),
      ),
    );
  }

  uploadProfile(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Select profile picture"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(30),
                child: const Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();

                  final image =
                      await imagePicker.getImage(source: ImageSource.camera);
                  setState(() {
                    if (image != null) {
                      img = File(image.path);
                    } else
                      print("No image selected!!!");
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(30),
                child: const Text("Choose from gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();

                  final image =
                      await imagePicker.getImage(source: ImageSource.gallery);
                  setState(() {
                    if (image != null) {
                      img = File(image.path);
                    } else {}
                    print("No image selected!!!");
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(30),
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  final _emailController = TextEditingController();
  final _unameController = TextEditingController();
  final _passController = TextEditingController();
  final _deptController = TextEditingController();
  final _batchController = TextEditingController();
  final _cpassController = TextEditingController();

  String _pass = '';
  String _uname = '';
  String _cpass = '';
  String _uemail = '';
  String _dept = '';
  String _batch = '';
  String _id = '';

  bool _isPassVisible1 = true;
  bool _isPassVisible2 = true;
  final _formKey = GlobalKey<FormState>();

  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _unameController.dispose();
    _batchController.dispose();
    _deptController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() => (setState(() {})));
  }

  @override
  Widget build(BuildContext context) {
    String reqId = widget.reqId;
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
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 15,
          ),
          Stack(
            children: [
              img != null
                  ? CircleAvatar(
                      radius: 40,
                      backgroundImage: FileImage(img!),
                      backgroundColor: Colors.red,
                    )
                  : const CircleAvatar(
                      radius: 64,
                      backgroundImage:
                          NetworkImage('https://i.stack.imgur.com/l60Hf.png'),
                      backgroundColor: Colors.red,
                    ),
              Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                  onPressed: () {
                    uploadProfile(context);
                  },
                  icon: const Icon(Icons.add_a_photo),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 24,
          ),

          FutureBuilder(
              future: methods().getStudentData(widget.reqId.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    std student = snapshot.data as std;
                    final email = TextEditingController(text: student.email);
                    final name = TextEditingController(text: student.name);
                    final batch = TextEditingController(text: student.batch);
                    final dept = TextEditingController(text: student.dept);
                    final id = TextEditingController(text: student.id);
                    print(student.name.toString());
                    return Form(
                      key: _formKey,
                      child: Column(children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 30, 10, 0),
                          child: TextFormField(
                            controller: name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Invalid input";
                              } else if (value.length < 4) {
                                return "name must be at least 4 characters";
                              }
                              return null;
                            },
                            // onChanged: (value) =>
                            //     setState(() => this._uname = value),
                            decoration: InputDecoration(
                              hintText: 'example name',
                              // labelText: "${data[4]['name']}",
                              border: OutlineInputBorder(),
                            ),
                            // autofillHints: [AutofillHints.],
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
                            controller: email,
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
                            // onChanged: (value) =>
                            //     setState(() => this._pass = value),
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
                              } else if (value != _passController.text) {
                                return "Please enter same password";
                              }
                              return null;
                            },
                            controller: _cpassController,
                            // onChanged: (value) =>
                            //     setState(() => this._cpass = value),
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
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 30, 10, 0),
                          child: TextFormField(
                            controller: dept,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Invalid input";
                              }
                              return null;
                            },
                            // onChanged: (value) =>
                            //     setState(() => this._dept = value),
                            decoration: InputDecoration(
                              hintText: 'Department of... ',
                              //labelText: "Enter batch",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 30, 10, 0),
                          child: TextFormField(
                            controller: batch,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Invalid input";
                              }
                              return null;
                            },
                            // onChanged: (value) =>
                            //     setState(() => this._batch = value),
                            decoration: InputDecoration(
                              hintText: 'Batch number',
                              //labelText: "Enter batch",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          child: Text('Submit'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.purpleAccent, // Background color
                            onPrimary: Colors.white70,

                            //splashFactory: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          onPressed: () async {
                            _uemail = email.text.trim();
                            _pass = _passController.text.trim();
                            _uname = name.text;
                            if (_formKey.currentState != null) {
                              if (_formKey.currentState!.validate() != false) {
                                FirebaseAuth _auth = FirebaseAuth.instance;
                                FirebaseFirestore _firebaseFirestore =
                                    FirebaseFirestore.instance;
                                try {
                                  UserCredential userCredential = await _auth
                                      .createUserWithEmailAndPassword(
                                    email: _uemail,
                                    password: _pass,
                                  );

                                  print(_uname);
                                  print(_uemail);
                                  print(_pass);

                                  User? _user = _auth.currentUser;
                                  String? photoUrl = await uploadImg(img!);

                                  var _userMap = {
                                    'uid': _user!.uid,
                                    'userName': _uname,
                                    'email': _user.email,
                                    'batch': _batch,
                                    'dept': _dept,
                                    'student_id': widget.reqId,
                                    'photoURL': photoUrl == null
                                        ? 'https://i.stack.imgur.com/l60Hf.png'
                                        : photoUrl,
                                  };
                                  print({_userMap});

                                  // await _firebaseFirestore
                                  //     .collection('Users')
                                  //     .doc(_user.uid)
                                  //     .set(_userMap);

                                  // print(_uname);
                                  // print(_uemail);
                                  // print(_pass);

                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return mailVerfication(
                                      userMap: _userMap,
                                    );
                                  }), (r) {
                                    return false;
                                  });
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    ShowSnackBarText(
                                        'No user found for that email.');
                                  } else if (e.code == 'wrong-password') {
                                    ShowSnackBarText(
                                        'Wrong password provided.');
                                  } else if (e.code == 'email-already-in-use') {
                                    ShowSnackBarText(
                                        "Email already registerd!");
                                  }
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
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
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
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                return logIn();
                              }), (r) {
                                return false;
                              });
                            }),
                      ]),
                    );
                  } else {
                    return Text("No data available");
                  }
                } else {
                  return Container(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              })

          // validateFormRemail(
          //   idReq: reqId,
          // )
        ]),
      ),
    );
  }
}

// class validateFormRemail extends StatefulWidget {
//   final idReq;

//   const validateFormRemail({
//     Key? key,
//     required this.idReq,
//   }) : super(key: key);

//   @override
//   State<validateFormRemail> createState() => _validateFormRemailState();
// }

// class _validateFormRemailState extends State<validateFormRemail> {
//   Future<List<Map<String, dynamic>?>> getData(String id) async {
//     List<Map<String, dynamic>?> docss = [];
//     final snapshot = await FirebaseFirestore.instance
//         .collection("students")
//         .doc(id)
//         .get()
//         .then((value) {
//       docss.add(value.data());
//     });
//     Logger().i(docss);
//     return docss;

//     // final data = snapshot.docs.map((e) => std.fromFirestore(e)).toList();
//   }

 

//   // late final data = getData(widget.idReq);
//   // String name ='';
// //   Future<List<Map<String, dynamic>>> data = getData(widget.idReq);
// // List<Map<String, dynamic>> dataList = await data;
// // String name = dataList[4][‘name'];

  

//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }
