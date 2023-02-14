import 'package:flutter/material.dart';
import 'package:ai1_clubs/LUCC/addPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai1_clubs/LUCC/postWidget.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
          backgroundColor: Colors.purple[200],
          centerTitle: false,
          title: Text("Posts"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.post_add_outlined,
                color: Colors.white70,
              ),
              onPressed: () async {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => addPost()));
              },
            ),
          ]),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Center(
                child: LinearProgressIndicator(),
              ),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) => Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: width > 600 ? width * 0.3 : 0,
                      vertical: width > 600 ? 15 : 0,
                    ),
                    child: postWidget(
                      snap: snapshot.data!.docs[index].data(),
                    ),
                  ));
        },
      ),
    );
  }
}
