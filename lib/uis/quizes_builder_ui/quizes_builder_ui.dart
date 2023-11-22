import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:smart_money_trading/models/quiz.dart';
import 'package:smart_money_trading/services/navigation_service.dart';
import 'package:smart_money_trading/uis/quizes_builder_ui/quiz_ui/landing_quiz_ui.dart';

class QuizesBuilderUI extends StatelessWidget {
  final Customer customer;
  const QuizesBuilderUI({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            title: Text("OXT Quizes"),
          ),
          StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("quizes").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(key: key),
                    ),
                  );
                }
                List<Quiz> list = snapshot.data!.docs
                    .map((doc) => Quiz.fromDocumentSnapshot(doc))
                    .toList();
                return SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    Quiz quiz = list[index];
                    return ListTile(
                      onTap: () {
                        NavigationService(context).push(LandingQuizUI(
                          quiz: quiz,
                        ));
                      },
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12.0),
                      leading: CircleAvatar(
                        child: Text("${index + 1}"),
                      ),
                      title: Text(quiz.title),
                      subtitle: Text(quiz.description),
                    );
                  }, childCount: snapshot.data!.docs.length)),
                );
              }),
        ],
      ),
    );
  }
}
