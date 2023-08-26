import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List groups;
  final bool isSecure;
  final bool isToxic;
  final num totalToxicCheck;
  final num toxicContents;

  const User({
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.bio,
    required this.groups,
    required this.isSecure,
    required this.isToxic,
    required this.totalToxicCheck,
    required this.toxicContents,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      groups: snapshot["groups"],
      isSecure: snapshot["isSecure"],
      isToxic: snapshot["isToxic"],
      totalToxicCheck: snapshot["totalToxicCheck"],
      toxicContents: snapshot["toxicContents"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "groups": groups,
        "isSecure": isSecure,
        "isToxic": isToxic,
        "totalToxicCheck": totalToxicCheck,
        "toxicContents": toxicContents,
      };
}
