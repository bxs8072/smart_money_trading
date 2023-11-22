import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_money_trading/models/quiz.dart';
import 'package:smart_money_trading/models/quiz_question.dart';
import 'package:smart_money_trading/services/navigation_service.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/uis/admin_panel_ui/manage_quizes_ui/quiz_question_ui/edit_quiz_question_ui.dart';

class QuestionsBuilder extends StatefulWidget {
  final Quiz quiz;
  const QuestionsBuilder({super.key, required this.quiz});

  @override
  State<QuestionsBuilder> createState() => _QuestionsBuilderState();
}

class _QuestionsBuilderState extends State<QuestionsBuilder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("quizQuestions")
            .where("quizId", isEqualTo: widget.quiz.docId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<QuizQuestion> quizQuestionList = snapshot.data!.docs
              .map((doc) => QuizQuestion.fromDocumentSnapshot(doc))
              .toList();
          return ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: quizQuestionList.length,
              itemBuilder: (context, i) {
                QuizQuestion quizQuestion = quizQuestionList[i];
                return ListTile(
                  contentPadding: const EdgeInsets.all(12.0),
                  title: Text("${i + 1}. ${quizQuestion.question}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        "Answer: ${quizQuestion.choices[quizQuestion.correctChoice - 1]}",
                        style: GoogleFonts.exo2(
                          color: Colors.green,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () {
                          NavigationService(context).push(
                            EditQuizQuestionUI(quizQuestion: quizQuestion),
                          );
                        },
                        label: Text("Edit Question ${i + 1}"),
                        icon: const Icon(Icons.edit_note),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: SizeService(context).width * 0.1),
                        child: const Divider(
                          color: Colors.blue,
                          thickness: 0.8,
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }
}
