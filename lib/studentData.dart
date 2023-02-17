import 'package:cloud_firestore/cloud_firestore.dart';

class std {
  final String email;
  final String id;

  final String name;
  final String batch;
  final String dept;

  const std({
    required this.name,
    required this.id,
    required this.email,
    required this.batch,
    required this.dept,
  });

  static std fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return std(
      name: snapshot["name"],
      id: snapshot["id"],
      email: snapshot["email"],
      dept: snapshot["dept"],
      batch: snapshot["batch"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "email": email,
        "dept": dept,
        "batch": batch,
      };
}
