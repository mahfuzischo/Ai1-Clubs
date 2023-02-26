import 'package:ai1_clubs/LUCC/commentWidget.dart';
import 'package:ai1_clubs/provider.dart';
import 'package:ai1_clubs/userData.dart';
import 'package:ai1_clubs/postData.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:ai1_clubs/methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai1_clubs/provider.dart';
import 'package:provider/provider.dart';

class comments extends StatefulWidget {
  final postId;
  final isPost;
  const comments({super.key, required this.postId, required this.isPost});

  @override
  State<comments> createState() => _commentsState();
}

class _commentsState extends State<comments> {
  final TextEditingController _commentEditingController =
      TextEditingController();

  void ShowSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  void addComment(String uid, String name, String profilePic) async {
    try {
      String result = await methods().addComment(
        widget.postId,
        _commentEditingController.text,
        uid,
        name,
        profilePic,
      );

      if (result != 'success') {
        ShowSnackBarText(result);
      }
      setState(() {
        _commentEditingController.text = "";
      });
    } catch (e) {
      ShowSnackBarText(
        e.toString(),
      );
    }
  }

//feb 26
  @override
  Widget build(BuildContext context) {
    final UseR user = Provider.of<provider>(context).getUser;
    var isPost = widget.isPost;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: const Text(
          'Comments',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: isPost == true
            ? FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.postId)
                .collection('comments')
                .snapshots()
            : FirebaseFirestore.instance
                .collection('events')
                .doc(widget.postId)
                .collection('comments')
                .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => CommentWidget(
              snap: snapshot.data!.docs[index],
            ),
          );
        },
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: _commentEditingController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.userName}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => addComment(
                  user.uid,
                  user.userName,
                  user.photoUrl,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
