import 'package:cloud_firestore/cloud_firestore.dart';

class SelectedChoice {
  final String quizQuestionId;
  int index;

  SelectedChoice(this.index, this.quizQuestionId);
  factory SelectedChoice.fromJson(dynamic jsonData) {
    return SelectedChoice(jsonData["index"], jsonData["quizQuestionId"]);
  }
}

class QuizAnswer {
  final String docId, quizId, firebaseUid;
  final Timestamp createdAt;
  final List<SelectedChoice> selectedChoices;

  QuizAnswer({
    required this.docId,
    required this.firebaseUid,
    required this.quizId,
    required this.createdAt,
    required this.selectedChoices,
  });

  Map<String, dynamic> get toJson => {
        "docId": docId,
        "createdAt": createdAt,
        "firebaseUid": firebaseUid,
        "quizId": quizId,
        "selectedChoices": selectedChoices
            .map((e) => {"quizQuestionId": e.quizQuestionId, "index": e.index})
            .toList(),
      };

  factory QuizAnswer.fromDocumentSnapshot(DocumentSnapshot doc) {
    return QuizAnswer(
      docId: doc.id,
      firebaseUid: doc["firebaseUid"],
      createdAt: doc["createdAt"],
      quizId: doc["quizId"],
      selectedChoices: List.from(doc["selectedChoices"])
          .map((e) => SelectedChoice.fromJson(e))
          .toList(),
    );
  }
}
