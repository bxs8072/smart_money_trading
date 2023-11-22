import 'package:cloud_firestore/cloud_firestore.dart';

class EducationMaterial {
  final String docId, title, subtitle, pdfUrl, imageUrl;
  final Timestamp createdAt, updatedAt;
  EducationMaterial(
      {required this.docId,
      required this.title,
      required this.subtitle,
      required this.pdfUrl,
      required this.imageUrl,
      required this.createdAt,
      required this.updatedAt});

  factory EducationMaterial.fromDocumentSnapshot(DocumentSnapshot doc) {
    return EducationMaterial(
      docId: doc.id,
      createdAt: doc["createdAt"],
      updatedAt: doc["updatedAt"],
      title: doc["title"],
      subtitle: doc["subtitle"],
      pdfUrl: doc["pdfUrl"],
      imageUrl: doc["imageUrl"],
    );
  }
}
