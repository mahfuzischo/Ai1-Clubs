import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class requestWidget extends StatelessWidget {
  final snap;
  const requestWidget({Key? key, required this.snap}) : super(key: key);
  Future<String> deleteReq(String reqId) async {
    String res = "Some error occurred";
    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(reqId)
          .delete();
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> allowReq(String reqId) async {
    String res = "Some error occurred";
    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(reqId)
          .set({'uid': reqId});
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              snap.data()['photoUrl'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Request"),
                          content: Text("Choose one option"),
                          actions: <Widget>[
                            ElevatedButton(
                                onPressed: () async {
                                  await allowReq(
                                    snap.data()['uid'].toString(),
                                  );
                                  await deleteReq(
                                    snap.data()['uid'].toString(),
                                  );
                                  Navigator.of(context).pop();
                                },
                                child: Text("Allow")),
                            ElevatedButton(
                                onPressed: () async {
                                  await deleteReq(
                                    snap.data()['uid'].toString(),
                                  );

                                  Navigator.of(context).pop();
                                },
                                child: Text("Delete"))
                          ],
                        );
                      });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: snap.data()['name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey)),
                          TextSpan(
                              text: '  ID: ',
                              style: TextStyle(color: Colors.grey[800])),
                          TextSpan(
                              text: ' ${snap.data()['sid']}',
                              style: TextStyle(color: Colors.grey[800])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
