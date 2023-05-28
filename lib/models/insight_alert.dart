import 'package:cloud_firestore/cloud_firestore.dart';

class InsightAlert {
  final String? docId;
  final String title;
  final String type;
  final String description;
  final Timestamp datetime;
  final Timestamp createdAt;
  String alertType;

  InsightAlert({
    this.docId,
    required this.title,
    required this.type,
    required this.description,
    required this.datetime,
    required this.createdAt,
    this.alertType = "INSIGHT_ALERT",
  });

  Map<String, dynamic> get toJson => {
        "docId": docId ?? "",
        "title": title,
        "type": type,
        "description": description,
        "datetime": datetime,
        "createdAt": createdAt,
        "alertType": alertType,
      };

  factory InsightAlert.fromDoc(DocumentSnapshot doc) {
    return InsightAlert(
      docId: doc.id,
      title: doc.get('title'),
      type: doc.get('type'),
      description: doc.get('description'),
      datetime: doc.get('datetime'),
      createdAt: doc.get('createdAt'),
      alertType: doc.get('alertType'),
    );
  }
}
