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

  factory std.fromSnap(DocumentSnapshot<Map<String, dynamic>> snap) {
    final snapshot = snap.data()!;

    return std(
      name: snapshot["name"],
      batch: snapshot["batch"],
      id: snapshot["id"],
      email: snapshot["email"],
      dept: snapshot["dept"],
    );
  }

  // factory std.fromFirestore(
  //   DocumentSnapshot<Map<String, dynamic>> snapshot,
  // ) {
  //   final data = snapshot.data();
  //   return std(
  //     name: data!['name'] ?? '',
  //     batch: data!['batch'] ?? '',
  //     dept: data!['dept'] ?? '',
  //     email: data!['email'] ?? '',
  //     id: data!['id'] ?? '',
  //   );
  // }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (batch != null) "batch": batch,
      if (dept != null) "dept": dept,
      if (email != null) "email": email,
      if (id != null) "id": id,
    };
  }

  toJson() => {
        "name": name,
        "id": id,
        "email": email,
        "dept": dept,
        "batch": batch,
      };
}
