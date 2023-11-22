import 'package:cloud_firestore/cloud_firestore.dart';

class Quiz {
  final String docId, title, description;
  final Timestamp createdAt, updatedAt;

  Quiz({
    required this.docId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Quiz.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Quiz(
      docId: doc.id,
      title: doc["title"],
      description: doc["description"],
      createdAt: doc["createdAt"],
      updatedAt: doc["updatedAt"],
    );
  }
}
