import 'package:cloud_firestore/cloud_firestore.dart';

class QuizQuestion {
  final String docId, quizId, question;
  final List<String> choices;
  final int correctChoice;
  final Timestamp createdAt, updatedAt;

  QuizQuestion({
    required this.docId,
    required this.quizId,
    required this.question,
    required this.choices,
    required this.correctChoice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuizQuestion.fromDocumentSnapshot(DocumentSnapshot doc) {
    return QuizQuestion(
      docId: doc.id,
      quizId: doc["quizId"],
      choices: List<String>.from(doc["choices"]),
      question: doc["question"],
      correctChoice: doc["correctChoice"],
      createdAt: doc["createdAt"],
      updatedAt: doc["updatedAt"],
    );
  }
}
