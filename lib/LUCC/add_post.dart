import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ai1_clubs/LUCC/news_feed.dart';

class add_post extends StatefulWidget {
  const add_post({super.key});

  @override
  State<add_post> createState() => _add_postState();
}

class _add_postState extends State<add_post> {
  int x = 0;
  int y = 0;

  String texts = '';
  String pic = '';
  String netPic = '';
  String picName = '';

  Map<String, dynamic> pictures = {};

  final _textsController = TextEditingController();

  final storage = FirebaseStorage.instance;

  void ShowSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  listFiles() async {
    final storageRef = FirebaseStorage.instance.ref("posts/");
    final listResult = await storageRef.listAll();
    String ss = listResult.toString();
    print('List result: $listResult');
    for (var item in listResult.items) {
      if (item != null) {
        x++;
      }
    }
  }

  downloadURL(String imgName) async {
    String c = imgName.toString();
    String dowloadURL = await storage.ref(c).getDownloadURL();
    return dowloadURL;
  }

  Future<void> uploadFile(String filepath, String filename) async {
    File file = File(filepath);
    // int z = x + 1;
    try {
      await storage.ref('posts/post_img1)').putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Column(
          children: <Widget>[
            Container(
              height: 360,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(downloadURL('posts/post_img1.jpg')))),
            ),
            SizedBox(
              height: 40,
              width: 60,
              child: IconButton(
                icon: Icon(
                  Icons.add_a_photo,
                  color: Colors.white70,
                ),
                onPressed: () async {
                  final _res = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.custom,
                      allowedExtensions: ['png', 'jpg', 'jpeg']);
                  if (_res == null) {
                    ShowSnackBarText('No file found!');
                    return null;
                  }
                  final path = _res.files.single.path!;
                  pic = path;
                  final fileName = _res.files.single.name;
                  picName = fileName;

                  // uploadFile(path, fileName);
                },
              ),
            ),
            TextField(
              onChanged: (value) => setState(() => texts = value),
              controller: _textsController,
              decoration: InputDecoration(
                hintText: 'Add',
                labelText: 'Text',
                prefixIcon: Icon(Icons.mail),
                suffixIcon: _textsController.text.isEmpty
                    ? Container(
                        width: 0,
                      )
                    : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => _textsController.clear(),
                      ),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 70,
              width: 230,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    uploadFile(pic, picName);

                    FirebaseFirestore _firebaseFirestore =
                        FirebaseFirestore.instance;
                    var a = {'post1': texts};

                    await _firebaseFirestore
                        .collection('posts')
                        .doc('post1')
                        .set(a);

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => newsFeed()));
                  },
                  icon: Icon(
                    Icons.post_add_rounded,
                    size: 15,
                  ),
                  label: Text(
                    'Done',
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple[200], // Background color
                    onPrimary: Colors.grey[400],

                    //splashFactory: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
