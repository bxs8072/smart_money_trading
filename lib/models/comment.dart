import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String? docId;
  final String uid;
  final String comment;
  final Timestamp createdAt;
  final Map<String, dynamic>? likes;

  Comment({
    this.docId,
    required this.uid,
    required this.comment,
    required this.createdAt,
    this.likes,
  });

  Map<String, dynamic> get toJson => {
        "uid": uid,
        "comment": comment,
        "createdAt": createdAt,
        "likes": likes ?? {},
      };

  factory Comment.fromJson(dynamic data) {
    return Comment(
      uid: data.get("uid"),
      comment: data.get("comment"),
      createdAt: data.get("createdAt"),
      likes: data.get("likes") ?? {},
    );
  }
  factory Comment.fromDocumentSnapshot(DocumentSnapshot data) {
    return Comment(
      docId: data.id,
      uid: data.get("uid"),
      comment: data.get("comment"),
      createdAt: data.get("createdAt"),
      likes: data.get("likes") ?? {},
    );
  }
}
