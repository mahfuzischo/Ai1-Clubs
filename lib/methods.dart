import 'package:ai1_clubs/userData.dart' as model;
import 'package:ai1_clubs/userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:ai1_clubs/studentData.dart' as model;
import 'package:ai1_clubs/studentData.dart';
import 'package:ai1_clubs/postData.dart' as model;
import 'package:ai1_clubs/postData.dart';
import 'package:ai1_clubs/eventData.dart';
import 'package:ai1_clubs/eventData.dart' as model;

class methods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.UseR> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('Users').doc(currentUser.uid).get();

    return model.UseR.fromSnap(documentSnapshot);
  }

  Future<List> getAllUsers() async {
    final snapshot = await _firestore.collection("Users").get();
    final allUsers = snapshot.docs.map((e) => UseR.fromFirebase(e)).toList();
    return allUsers;
  }

  Future<model.std> getStudentData(String id) async {
    final snapshot = await _firestore
        .collection('students')
        .where("id", isEqualTo: id)
        .get();
    final studentData = snapshot.docs.map((e) => std.fromSnap(e)).single;
    return studentData;
  }

  Future<model.Event> getEventData(String id) async {
    final snapshot = await _firestore
        .collection('events')
        .where("eventId", isEqualTo: id)
        .get();
    final eventData = snapshot.docs.map((e) => Event.fromSnap(e)).single;
    return eventData;
  }

  Future<model.Post> getPostData(String postId) async {
    final snapshot = await _firestore
        .collection('posts')
        .where("postId", isEqualTo: postId)
        .get();
    final pOstData = snapshot.docs.map((e) => Post.fromSnap(e)).single;
    return pOstData;
  }

  Future<String> addComment(String postId, String text, String uid, String name,
      String profilePic) async {
    String snack = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        snack = 'Comment successfully added';
      } else {
        snack = "Please enter text";
      }
    } catch (e) {
      snack = e.toString();
    }
    return snack;
  }
}
