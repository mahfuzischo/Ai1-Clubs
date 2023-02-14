import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String description;
  final String uid;
  final String userName;
  final String eventId;
  final DateTime datePublished;
  final String eventUrl;
  final String photoURL;

  const Event({
    required this.description,
    required this.uid,
    required this.userName,
    required this.eventId,
    required this.datePublished,
    required this.eventUrl,
    required this.photoURL,
  });

  static Event fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Event(
        description: snapshot["description"],
        uid: snapshot["uid"],
        eventId: snapshot["eventId"],
        datePublished: snapshot["datePublished"],
        userName: snapshot["userName"],
        eventUrl: snapshot['eventUrl'],
        photoURL: snapshot['photoURL']);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "userName": userName,
        "eventId": eventId,
        "datePublished": datePublished,
        'eventUrl': eventUrl,
        'photoURL': photoURL
      };
}
