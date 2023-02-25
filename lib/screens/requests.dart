import 'package:ai1_clubs/provider.dart';
import 'package:ai1_clubs/screens/requestWidget.dart';
import 'package:ai1_clubs/userData.dart';
import 'package:ai1_clubs/postData.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:ai1_clubs/methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai1_clubs/provider.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class requests extends StatefulWidget {
  const requests({
    super.key,
  });

  @override
  State<requests> createState() => _requestsState();
}

class _requestsState extends State<requests> {
  void ShowSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white70,
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
        backgroundColor: Colors.grey[700],
        title: const Text(
          'Requests',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('requests').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => requestWidget(
              snap: snapshot.data!.docs[index],
            ),
          );
        },
      ),
      // text input
    );
  }
}
