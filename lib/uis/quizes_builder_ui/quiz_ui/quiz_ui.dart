import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_money_trading/models/quiz.dart';
import 'package:smart_money_trading/models/quiz_answer.dart';
import 'package:smart_money_trading/models/quiz_question.dart';

class QuizUI extends StatefulWidget {
  final Quiz quiz;
  final List<QuizAnswer> quizAnswers;
  const QuizUI({super.key, required this.quiz, required this.quizAnswers});

  @override
  State<QuizUI> createState() => _QuizUIState();
}

class _QuizUIState extends State<QuizUI> {
  List<QuizQuestion> quizQuestions = [];
  List<SelectedChoice> selectedChoices = [];

  Future<void> initQuizQuestion() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection("quizQuestions")
        .where("quizId", isEqualTo: widget.quiz.docId)
        .get();
    setState(() {
      quizQuestions = querySnapshot.docs
          .map((doc) => QuizQuestion.fromDocumentSnapshot(doc))
          .toList();
    });
    setState(() {
      if (widget.quizAnswers.isEmpty) {
        selectedChoices = querySnapshot.docs
            .map((doc) => SelectedChoice(-1, doc.id))
            .toList();
      } else {
        selectedChoices = widget.quizAnswers[0].selectedChoices;
      }
    });
  }

  int get correctScore {
    int correct = 0;
    for (QuizQuestion quizQuestion in quizQuestions) {
      int correctChoice = quizQuestion.correctChoice;
      for (SelectedChoice selectedChoice in selectedChoices) {
        if (selectedChoice.index == correctChoice - 1 &&
            selectedChoice.quizQuestionId == quizQuestion.docId) {
          correct++;
        }
      }
    }
    return correct;
  }

  Future<void> onQuizSubmit() async {
    if (widget.quizAnswers.isEmpty) {
      await FirebaseFirestore.instance.collection("quizAnswers").doc().set(
            QuizAnswer(
              docId: "",
              firebaseUid: FirebaseAuth.instance.currentUser!.uid,
              quizId: widget.quiz.docId,
              createdAt: Timestamp.now(),
              selectedChoices: selectedChoices,
            ).toJson,
          );
    } else {
      await FirebaseFirestore.instance
          .collection("quizAnswers")
          .doc(widget.quizAnswers[0].docId)
          .delete();
      await initQuizQuestion();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initQuizQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        if (widget.quizAnswers.isNotEmpty)
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            sliver: SliverToBoxAdapter(
              child: Card(
                elevation: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "You scored $correctScore out of ${quizQuestions.length}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.exo2(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${(correctScore * 100 / quizQuestions.length).toStringAsFixed(2)}%",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.exo2(
                          fontSize: 35.0,
                          fontWeight: FontWeight.w900,
                          color: correctScore * 100 / quizQuestions.length < 70
                              ? Colors.red
                              : correctScore * 100 / quizQuestions.length < 85
                                  ? Colors.yellow.shade700
                                  : Colors.green,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (correctScore == quizQuestions.length)
                        Center(
                          child: Text(
                            "Congratulations, you got it all correct!",
                            style: GoogleFonts.exo2(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      if (correctScore != quizQuestions.length)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            elevation: 0,
                          ),
                          onPressed: onQuizSubmit,
                          child: Text(
                            "Take Quiz Again",
                            style: GoogleFonts.exo2(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        const SliverToBoxAdapter(
          child: Center(),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              QuizQuestion quizQuestion = quizQuestions[index];
              SelectedChoice selectedChoice = selectedChoices.firstWhere(
                  (SelectedChoice a) => a.quizQuestionId == quizQuestion.docId);
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                child: Column(
                  children: [
                    Text(
                      '${index + 1}. ${quizQuestion.question}',
                      style: GoogleFonts.exo2(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GridView.builder(
                        shrinkWrap: true,
                        primary: false,
                        padding: const EdgeInsets.all(0.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 5,
                        ),
                        itemCount: quizQuestion.choices.length,
                        itemBuilder: (context, i) {
                          Color buttonBgColor = Colors.black87;

                          if (widget.quizAnswers.isEmpty) {
                            if (selectedChoice.index == -1) {
                              buttonBgColor = Colors.black87;
                            } else {
                              if (quizQuestion.choices[i] ==
                                  quizQuestion.choices[selectedChoice.index]) {
                                buttonBgColor = Colors.blue;
                              }
                            }
                          } else {
                            if (selectedChoice.index ==
                                    quizQuestion.correctChoice - 1 &&
                                quizQuestion.choices[i] ==
                                    quizQuestion
                                        .choices[selectedChoice.index]) {
                              buttonBgColor = Colors.green;
                            } else {
                              if (quizQuestion.choices[i] ==
                                  quizQuestion.choices[selectedChoice.index]) {
                                buttonBgColor = Colors.red;
                              } else {
                                buttonBgColor = Colors.grey.shade400;
                              }
                            }
                          }

                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0.00,
                              backgroundColor: buttonBgColor,
                            ),
                            onPressed: widget.quizAnswers.isNotEmpty
                                ? () {}
                                : () {
                                    setState(() {
                                      if (selectedChoice.index == i) {
                                        selectedChoices[index].index = -1;
                                      } else {
                                        selectedChoices[index].index = i;
                                      }
                                    });
                                  },
                            child: Text(
                              quizQuestion.choices[i],
                              style: GoogleFonts.exo2(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }),
                    const Padding(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 10),
                      child: Divider(
                        thickness: 2.0,
                        color: Colors.black26,
                      ),
                    ),
                  ],
                ),
              );
            },
            childCount: quizQuestions.length,
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
            addSemanticIndexes: true,
          ),
        ),
        if (widget.quizAnswers.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 0,
                ),
                onPressed: selectedChoices.map((e) => e.index).contains(-1)
                    ? null
                    : onQuizSubmit,
                child: Text(
                  "Submit",
                  style: GoogleFonts.exo2(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
          ),
        ),
      ],
    );
  }
}
