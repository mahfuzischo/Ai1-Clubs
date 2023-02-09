import 'dart:io';
import 'package:ai1_clubs/LUCC/newsFeed.dart';
import 'package:ai1_clubs/postData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ai1_clubs/LUCC/news_feed.dart';

class addPost extends StatefulWidget {
  const addPost({super.key});

  @override
  State<addPost> createState() => _addPostState();
}

class _addPostState extends State<addPost> {
  final TextEditingController _captionController = TextEditingController();

  bool isLoading = false;

  File? _image;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore fire = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getUsrName() async {
    dynamic uid = _auth.currentUser!.uid;
    String uname = '';
    var collection = fire.collection('Users');
    var docSnapshot = await collection.doc(uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      var value = data?['userName'];
      uname = value.toString();
      print(uname);
    }
    return uname;
  }

  final imagePicker = ImagePicker();

  _uploadImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a post"),
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
                      _image = File(image.path);
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
                      _image = File(image.path);
                    } else
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

  void ShowSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Future<String> getPicUrl() async {
    dynamic uid = _auth.currentUser!.uid;
    String url = '';
    var collection = fire.collection('Users');
    var docSnapshot = await collection.doc(uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      var value = data?['photoURL'];
      url = value.toString();
      print(url);
    }
    return url;
  }

  Future<String> _uploadImg(String childName, File file) async {
    String _picname = const Uuid().v1();
    Reference ref = _storage
        .ref()
        .child(childName)
        .child(_auth.currentUser!.uid)
        .child(_picname);
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snap = await uploadTask;
    String dldURL = await snap.ref.getDownloadURL();
    print("photourl:" + dldURL);
    return dldURL;
  }

  Future<String> _uploadPost(String uid, dynamic userName) async {
    setState(() {
      isLoading = true;
    });
    String res = "Error occured";
    try {
      print(_captionController);
      String postUrl = await _uploadImg("posts", _image!);
      String photoUrl = await getPicUrl();

      print("Pic url" + postUrl);
      String postId = const Uuid().v1();

      Post post = Post(
          description: _captionController.text,
          uid: uid,
          userName: userName,
          postId: postId,
          datePublished: DateTime.now(),
          photoURL: photoUrl,
          postUrl: postUrl);

      fire.collection('posts').doc(postId).set(post.toJson());

      res = "Successful";
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ShowSnackBarText(e.toString());
    }
    if (res == "Successful") {
      ShowSnackBarText("Post successfully uploaded.");
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return const FeedScreen();
      }), (r) {
        return false;
      });
    } else {
      ShowSnackBarText("Error uploading post.");
    }
    return res;
  }

  void dispose() {
    super.dispose();
    _captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white38,
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        title: const Text("Create Post"),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () async {
                _uploadPost(_auth.currentUser!.uid, await getUsrName());
              },
              child: const Text(
                "Post",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
          child: Column(
            children: [
              isLoading
                  ? const LinearProgressIndicator()
                  : const Padding(padding: EdgeInsets.only(top: 0.0)),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(getPicUrl().toString()),
                    radius: 25,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  // Text(
                  //   "$getUsrName",
                  //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  // )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  controller: _captionController,
                  decoration: InputDecoration(
                      hintText: "Write a caption...",
                      label: Text("Write a caption..."),
                      border: OutlineInputBorder()),
                  maxLines: 8,
                ),
              ),
              Divider(
                height: 20,
              ),
              Container(
                  child: _image != null
                      ? SizedBox(
                          height: 250,
                          width: 200,
                          child: Container(
                            //post image need to add
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(_image!),
                                    alignment: FractionalOffset.topCenter)),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Center(
                            child: IconButton(
                              color: Color.fromRGBO(238, 255, 65, 1),
                              tooltip: "Upload Picture",
                              iconSize: 50,
                              icon: const Icon(
                                Icons.upload,
                              ),
                              onPressed: () => _uploadImage(context),
                            ),
                          ),
                        ))
            ],
          ),
        ),
      ),
    );
  }
}
