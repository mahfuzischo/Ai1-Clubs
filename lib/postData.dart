import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Post {
  final String description;
  final String uid;
  final String userName;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String photoURL;

  const Post({
    required this.description,
    required this.uid,
    required this.userName,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.photoURL,
  });

  factory Post.fromSnap(DocumentSnapshot<Map<dynamic, dynamic>> snap) {
    final snapshot = snap.data()!;

    return Post(
        description: snapshot["description"],
        uid: snapshot["uid"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"].toDate(),
        userName: snapshot["userName"],
        postUrl: snapshot['postUrl'],
        photoURL: snapshot['photoURL']);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "userName": userName,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'photoURL': photoURL
      };
}
