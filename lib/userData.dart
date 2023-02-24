import 'package:cloud_firestore/cloud_firestore.dart';

class UseR {
  final String email;
  final String uid;
  final String photoUrl;
  final String userName;
  final String batch;
  final String dept;
  final String student_id;

  const UseR({
    required this.userName,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.batch,
    required this.dept,
    required this.student_id,
  });

  static UseR fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UseR(
        userName: snapshot["userName"],
        uid: snapshot["uid"],
        email: snapshot["email"],
        photoUrl: snapshot["photoURL"],
        dept: snapshot["dept"],
        batch: snapshot["batch"],
        student_id: snapshot["student_id"]);
  }

  factory UseR.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return UseR(
        userName: snapshot["userName"],
        uid: snapshot["uid"],
        email: snapshot["email"],
        photoUrl: snapshot["photoURL"],
        dept: snapshot["dept"],
        batch: snapshot["batch"],
        student_id: snapshot["student_id"]);
  }

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "uid": uid,
        "email": email,
        "photoURL": photoUrl,
        "dept": dept,
        "batch": batch,
        "student_id": student_id,
      };

  static fromFirebase(QueryDocumentSnapshot<Map<String, dynamic>> e) {}
}
