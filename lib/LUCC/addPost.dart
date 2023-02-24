import 'dart:io';
import 'package:ai1_clubs/LUCC/newsFeed.dart';
import 'package:ai1_clubs/postData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ai1_clubs/provider.dart';
import 'package:provider/provider.dart';

class addPost extends StatefulWidget {
  const addPost({super.key});

  @override
  State<addPost> createState() => _addPostState();
}

class _addPostState extends State<addPost> {
  // Future<String> getUsrName() async {
  //   dynamic uid = _auth.currentUser!.uid;
  //   String uname = '';
  //   var collection = fire.collection('Users');
  //   var docSnapshot = await collection.doc(uid).get();
  //   if (docSnapshot.exists) {
  //     Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
  //     var value = data['userName'];
  //     uname = value;
  //     print(uname);
  //   }
  //   return uname;
  // }

  @override
  void initState() {
    super.initState();
    // this.mname = getUsrName().toString();
    // print("name=" + mname);
  }

  final TextEditingController _captionController = TextEditingController();

  bool isLoading = false;
  String mname = '';

  File? _image;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore fire = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
        duration: Duration(seconds: 3),
        content: Text(text),
      ),
    );
  }

  Future<int> _listFiles() async {
    int x = 0;
    final storageRef = FirebaseStorage.instance.ref("posts/");
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
    int g = await _listFiles();
    int k = g + 1;
    String _picname = "postimage$k";
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

  Future<String> _uploadPost(
      String uid, String userName, String photoURL) async {
    setState(() {
      isLoading = true;
    });
    String result = "Error occured";
    String v = _captionController.toString();
    try {
      print("caption  :  $v");
      String postUrl = await _uploadImg("posts", _image!);
      String photoUrl = await getPicUrl();

      String _postId = const Uuid().v1();

      print("Pic url" + postUrl);

      Post post = Post(
          description: _captionController.text,
          uid: uid,
          userName: userName,
          postId: _postId,
          datePublished: DateTime.now(),
          photoURL: photoUrl,
          postUrl: postUrl);

      fire.collection('posts').doc(_postId).set(post.toJson());

      result = "Successful";
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
      ShowSnackBarText(e.toString());
    }
    if (result == "Successful") {
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
    return result;
  }

  void dispose() {
    super.dispose();
    _captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider _userProvider = Provider.of<provider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white38,
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        title: const Text("Create Post"),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () {
                _uploadPost(
                  _userProvider.getUser.uid,
                  _userProvider.getUser.userName,
                  _userProvider.getUser.photoUrl,
                );
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
                    backgroundImage: NetworkImage(
                      _userProvider.getUser.photoUrl,
                    ),
                    radius: 25,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    _userProvider.getUser.userName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  )
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
                          child: InkWell(
                            onDoubleTap: () {
                              setState(() {
                                _image = null;
                                ShowSnackBarText("Image successfully removed");
                              });
                            },
                            splashColor: Colors.blue,
                            child: Ink.image(
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                                image: FileImage(_image!)),
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
