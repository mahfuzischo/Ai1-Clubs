import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String batch;
  final String dept;
  final String student_id;

  const User({
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.batch,
    required this.dept,
    required this.student_id,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        username: snapshot["username"],
        uid: snapshot["uid"],
        email: snapshot["email"],
        photoUrl: snapshot["photoUrl"],
        dept: snapshot["dept"],
        batch: snapshot["batch"],
        student_id: snapshot["student_id"]);
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "dept": dept,
        "batch": batch,
        "student_id": student_id,
      };
}
