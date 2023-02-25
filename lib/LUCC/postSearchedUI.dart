import 'dart:io';
import 'package:ai1_clubs/screens/registration.dart';
import 'package:intl/intl.dart';
import 'package:ai1_clubs/LUCC/comments.dart';
import 'package:ai1_clubs/userData.dart' as model;
import 'package:ai1_clubs/postData.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ai1_clubs/LUCC/editPost.dart';
import 'package:ai1_clubs/methods.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../postData.dart';

class postSearched extends StatefulWidget {
  final snap;
  const postSearched({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<postSearched> createState() => _postSearchedState();
}

class _postSearchedState extends State<postSearched> {
  @override
  void initState() {
    super.initState();
    getCommentLen();
  }

  // void ShowSnackBarText(String text) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(text),
  //     ),
  //   );
  // }

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _fire = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userName = '';
  int commentLen = 0;

  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _fire.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  getCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (e) {
      Text(
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: Text("Post"),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: methods().getPostData(widget.snap.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done ||
                snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                Post post = snapshot.data as Post;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(
                                post.photoURL,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      post.userName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            post.uid == _auth.currentUser!.uid
                                ? PopupMenuButton(
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem<int>(
                                          value: 0,
                                          child: Text("Delete"),
                                        ),
                                        PopupMenuItem<int>(
                                          value: 1,
                                          child: Text("Edit"),
                                        ),
                                      ];
                                    },
                                    onSelected: (value) {
                                      if (value == 0) {
                                        deletePost(
                                          post.postId,
                                        );

                                        Navigator.of(context).pop();
                                      }
                                      if (value == 1) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                editPost(reqID: post.postId),
                                          ),
                                        );
                                      }
                                    },
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        child: Image.network(
                          post.postUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: IconButton(
                              icon: const Icon(
                                Icons.comment_outlined,
                              ),
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => comments(
                                    isPost: true,
                                    postId: post.postId,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                top: 8,
                              ),
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.white),
                                  children: [
                                    TextSpan(
                                      text: post.userName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${post.description}',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                top: 8,
                              ),
                              child: Text(
                                DateFormat.yMMMd().format(post.datePublished),
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              //   padding: const EdgeInsets.symmetric(vertical: 4),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
            }
            return Container(
              child: Text("Error occured!!"),
            );
          }),
    );
  }
}
