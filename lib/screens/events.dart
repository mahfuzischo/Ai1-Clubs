import 'package:ai1_clubs/LUCC/lucc_home.dart';
import 'package:ai1_clubs/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:ai1_clubs/screens/addEvent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai1_clubs/screens/eventWidget.dart';
import 'package:ai1_clubs/screens/searchScreen.dart';

class eventScreen extends StatefulWidget {
  const eventScreen({Key? key}) : super(key: key);

  @override
  State<eventScreen> createState() => _eventScreenState();
}

class _eventScreenState extends State<eventScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
          backgroundColor: Colors.purple[200],
          centerTitle: false,
          title: Text("Events"),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white70,
            ),
            onPressed: () async {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LUCC_Home()));
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white70,
              ),
              onPressed: () async {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
            ),
            isAdmin == true
                ? IconButton(
                    icon: Icon(
                      Icons.post_add_outlined,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => addEvent()));
                    },
                  )
                : Container(),
          ]),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('events')
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
                    child: eventWidget(
                      snap: snapshot.data!.docs[index].data(),
                    ),
                  ));
        },
      ),
    );
  }
}
