import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_money_trading/models/quiz.dart';
import 'package:smart_money_trading/models/quiz_answer.dart';
import 'package:smart_money_trading/uis/quizes_builder_ui/quiz_ui/quiz_ui.dart';

class LandingQuizUI extends StatefulWidget {
  final Quiz quiz;
  const LandingQuizUI({super.key, required this.quiz});

  @override
  State<LandingQuizUI> createState() => _LandingQuizUIState();
}

class _LandingQuizUIState extends State<LandingQuizUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(widget.quiz.title),
        ),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("quizAnswers")
                .where("quizId", isEqualTo: widget.quiz.docId)
                .where("firebaseUid",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                List<QuizAnswer> quizAnswers = snapshot.data!.docs
                    .map((doc) => QuizAnswer.fromDocumentSnapshot(doc))
                    .toList();
                return QuizUI(quiz: widget.quiz, quizAnswers: quizAnswers);
              }
            }),
      ],
    ));
  }
}
