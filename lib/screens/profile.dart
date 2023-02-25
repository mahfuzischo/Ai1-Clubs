import 'dart:io';

import 'package:ai1_clubs/screens/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:ai1_clubs/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uuid/uuid.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  String _uemail = '';
  String _uname = '';

  File? img;
  final imagePicker = ImagePicker();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(_auth.currentUser!.uid)
        .update({'photoURL': dldURL});
    print("photourl:" + dldURL);
    return dldURL;
  }

  updateProfile(BuildContext context) async {
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
                      uploadImg(img!);
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
                      uploadImg(img!);
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

  @override
  Widget build(BuildContext context) {
    provider _userProvider = Provider.of<provider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        leading: IconButton(
          icon: Icon(
            size: 30,
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () async {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return home();
            }), (r) {
              return false;
            });
          },
        ),
        elevation: 0,
        title: Text(
          'Profile',
        ),
        centerTitle: true,
      ),
      body: Container(
          color: Colors.white70,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: Column(mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              NetworkImage(_userProvider.getUser.photoUrl),
                          backgroundColor: Colors.grey,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 80,
                          child: IconButton(
                            onPressed: () {
                              updateProfile(context);
                            },
                            icon: const Icon(Icons.add_a_photo),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      height: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userProvider.getUser.userName,
                          style: TextStyle(
                            color: Colors.black38,
                            letterSpacing: 2.0,
                            fontSize: 15.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Student ID: " + _userProvider.getUser.student_id,
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 2.0,
                            fontSize: 15.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Department: " + _userProvider.getUser.dept,
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 2.0,
                            fontSize: 15.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Batch: " + _userProvider.getUser.batch,
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 2.0,
                            fontSize: 15.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "E-mail: " + _userProvider.getUser.email,
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 2.0,
                            fontSize: 15.0,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ]))),
    );
  }
}
//feb 26