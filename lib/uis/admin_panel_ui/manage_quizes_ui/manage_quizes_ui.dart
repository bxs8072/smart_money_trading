import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_money_trading/models/quiz.dart';
import 'package:smart_money_trading/services/navigation_service.dart';
import 'package:smart_money_trading/uis/admin_panel_ui/manage_quizes_ui/quiz_ui/add_quiz_ui.dart';
import 'package:smart_money_trading/uis/admin_panel_ui/manage_quizes_ui/quiz_ui/edit_quiz_ui.dart';

class ManageQuizesUI extends StatefulWidget {
  const ManageQuizesUI({super.key});

  @override
  State<ManageQuizesUI> createState() => _ManageQuizesUIState();
}

class _ManageQuizesUIState extends State<ManageQuizesUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        elevation: 0.0,
        onPressed: () {
          NavigationService(context).push(
            AddQuizUI(
              key: widget.key,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            key: widget.key,
            title: const Text("Manage OXT Quizes"),
            pinned: true,
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("quizes")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        key: widget.key,
                      ),
                    ),
                  );
                }

                List<Quiz> quizList = snapshot.data!.docs
                    .map((e) => Quiz.fromDocumentSnapshot(e))
                    .toList();

                return SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        Quiz quiz = quizList[index];
                        return Card(
                          elevation: 0.0,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12.0),
                            leading: CircleAvatar(
                              backgroundColor: Colors.black87,
                              child: Text(
                                "${index + 1}",
                                style: GoogleFonts.exo2(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            title: Text(quiz.title),
                            subtitle: Text(quiz.description),
                            onTap: () {
                              NavigationService(context).push(
                                EditQuizUI(quiz: quiz),
                              );
                            },
                          ),
                        );
                      },
                      childCount: quizList.length,
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
