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
import 'package:cached_network_image/cached_network_image.dart';

//feb 26
class postWidget extends StatefulWidget {
  final snap;
  const postWidget({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<postWidget> createState() => _postWidgetState();
}

class _postWidgetState extends State<postWidget> {
  void ShowSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

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

  @override
  void initState() {
    super.initState();
    getCommentLen();
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
      ShowSnackBarText(
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(
                    widget.snap['photoURL'].toString(),
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
                          widget.snap['userName'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.snap['uid'].toString() == _auth.currentUser!.uid
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
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Delete"),
                                    content: Text(
                                        "Are you sure you want to delete this post?"),
                                    actions: <Widget>[
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(context);
                                          },
                                          child: Text("Cancel")),
                                      ElevatedButton(
                                          onPressed: () async {
                                            await deletePost(
                                              widget.snap['postId'].toString(),
                                            ).then((value) =>
                                                Navigator.of(context).pop());
                                          },
                                          child: Text("Yes"))
                                    ],
                                  );
                                  Navigator.of(context).pop(context);
                                });
                          }
                          if (value == 1) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => editPost(
                                  reqID: widget.snap['postId'].toString(),
                                ),
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
              widget.snap['postUrl'].toString(),
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
                        postId: widget.snap['postId'].toString(),
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
                          text: widget.snap['userName'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['description']}',
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
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(
                      color: Colors.black87,
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
