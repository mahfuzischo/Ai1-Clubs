import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:cached_network_image/cached_network_image.dart';

class lucc_album extends StatefulWidget {
  const lucc_album({super.key});

  @override
  State<lucc_album> createState() => _lucc_albumState();
}

class _lucc_albumState extends State<lucc_album> with TickerProviderStateMixin {
  Future<void> refresh() async {
    return await Future.delayed(Duration(seconds: 2));
  }

  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
  }

  final imagePicker = ImagePicker();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  File? _image;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore fire = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int x = 0;
  int y = 0;

  int a = 1;

  List<Image> lucc_imgList = [];

  void ShowSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Text(text),
      ),
    );
  }

  Future<int> _listFiles() async {
    int x = 0;
    final storageRef = FirebaseStorage.instance.ref("lucc_album/");
    final listResult = await storageRef.listAll();
    String ss = listResult.toString();
    print('List result: $listResult');
    for (var item in listResult.items) {
      if (item != null) {
        x++;
      }
    }
    print("Number of pics : $x");
    return x;
  }

  Future<String> _uploadImg(File file) async {
    int g = await _listFiles();
    int k = g + 1;
    String _picname = "LUCCimage$k";
    Reference ref = _storage.ref().child("lucc_album").child(_picname);
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snap = await uploadTask;
    String dldURL = await snap.ref.getDownloadURL();
    print("photourl:     " + dldURL);
    return dldURL;
  }

  Future<String> _uploadImgUrl(File img) async {
    // String s = "Failed";
    String photoid = Uuid().v1();
    String x = await _uploadImg(img);
    print(x.toString());
    await fire.collection('luccAlbum').doc(photoid).set({"photoURL": x});
    return x;
  }

  late AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[600],
          title: Text("LUCC Album"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add_a_photo,
                color: Colors.white70,
              ),
              onPressed: () async {
                final image =
                    await imagePicker.getImage(source: ImageSource.gallery);
                setState(() {
                  if (image != null) {
                    _image = File(image.path);
                  } else
                    ShowSnackBarText("No image selected");
                });
                _uploadImgUrl(_image!);
              },
            ),
          ],
          elevation: 0,
        ),
        body: LiquidPullToRefresh(
          animSpeedFactor: 5,
          child: gg(),
          onRefresh: refresh,
          height: 250,
          backgroundColor: Colors.grey[600],
          color: Colors.green[200],
          showChildOpacityTransition: true,
        ));
  }

//feb 26

  Widget gg() {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('luccAlbum')
            .where('photoURL', isNotEqualTo: null)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.waiting) {
            return GridView.builder(
              shrinkWrap: true,
              itemCount: (snapshot.data! as dynamic).docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                //childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];

                return InkWell(
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return Center(
                            child: Material(
                              type: MaterialType.transparency,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[600]),
                                padding: EdgeInsets.all(15),
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: 320,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image(
                                    image: NetworkImage(snap['photoURL']),
                                    fit: BoxFit.cover,
                                    width: 300,
                                    height: 300,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }));
                  },
                  child: Image(
                    image: NetworkImage(snap['photoURL']),
                    fit: BoxFit.cover,
                  ),
                );

                // return Container(
                //   child: Image(
                //     image: NetworkImage(snap['photoURL']),
                //     fit: BoxFit.cover,
                //   ),
                // );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
