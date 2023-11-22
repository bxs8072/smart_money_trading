import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_money_trading/models/quiz_question.dart';
import 'package:smart_money_trading/services/size_service.dart';

class EditQuizQuestionUI extends StatefulWidget {
  final QuizQuestion quizQuestion;

  const EditQuizQuestionUI({super.key, required this.quizQuestion});

  @override
  State<EditQuizQuestionUI> createState() => _EditQuizQuestionUIState();
}

class _EditQuizQuestionUIState extends State<EditQuizQuestionUI> {
  TextEditingController questionController = TextEditingController();
  List<TextEditingController> choiceControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  int correctChoice = 1;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> onSubmit() async {
    if (formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection("quizQuestions")
          .doc(widget.quizQuestion.docId)
          .update({
        "question": questionController.text.trim(),
        "correctChoice": correctChoice,
        "choices":
            choiceControllers.map((e) => e.text.trim().toString()).toList(),
        "updatedAt": Timestamp.now(),
      }).then((value) {
        Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    questionController.text = widget.quizQuestion.question;
    for (int i = 0; i < choiceControllers.length; i++) {
      choiceControllers[i].text = widget.quizQuestion.choices[i];
    }
    correctChoice = widget.quizQuestion.correctChoice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Quiz Question"),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
              child: TextFormField(
                controller: questionController,
                keyboardType: TextInputType.text,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: "Quiz Question",
                  labelStyle: TextStyle(color: Colors.black),
                ),
                validator: (val) {
                  if (val!.isEmpty) return "Enter Quiz Question";
                  return null;
                },
                onChanged: (val) {
                  setState(() {});
                },
              ),
            ),
            SizedBox(height: SizeService(context).verticalPadding),
            Column(
              children: choiceControllers
                  .map(
                    (choiceController) => Container(
                      margin: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: choiceController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText:
                              "Choice ${choiceControllers.indexOf(choiceController) + 1}",
                          labelStyle: const TextStyle(color: Colors.black),
                        ),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter Choice ${choiceControllers.indexOf(choiceController) + 1}";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white,
              ),
              child: DropdownButton(
                value: correctChoice,
                elevation: 0,
                borderRadius: BorderRadius.circular(12.0),
                alignment: Alignment.center,
                isExpanded: true,
                isDense: false,
                underline: const Center(),
                items: [1, 2, 3, 4]
                    .map(
                      (val) => DropdownMenuItem(
                        value: val,
                        key: Key(val.toString()),
                        child: Text(
                          val.toString(),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    correctChoice = val!;
                  });
                },
              ),
            ),
            SizedBox(height: SizeService(context).verticalPadding),
            ElevatedButton(
              onPressed: onSubmit,
              child: const Text("Update Question"),
            ),
          ],
        ),
      ),
    );
  }
}
