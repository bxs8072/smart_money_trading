import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_money_trading/models/quiz.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/uis/admin_panel_ui/manage_quizes_ui/quiz_question_ui/add_quiz_question_ui.dart';
import 'package:smart_money_trading/uis/admin_panel_ui/manage_quizes_ui/questions_builder.dart';

class EditQuizUI extends StatefulWidget {
  final Quiz quiz;
  const EditQuizUI({super.key, required this.quiz});

  @override
  State<EditQuizUI> createState() => _EditQuizUIState();
}

class _EditQuizUIState extends State<EditQuizUI> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> onSubmit() async {
    if (formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection("quizes")
          .doc(widget.quiz.docId)
          .update({
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
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
    titleController.text = widget.quiz.title;
    descriptionController.text = widget.quiz.description;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Editing Quiz"),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.black87,
            extendedTextStyle: GoogleFonts.exo2(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
            onPressed: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return AddQuizQuestionUI(
                      key: widget.key,
                      quiz: widget.quiz,
                    );
                  });
            },
            icon: const Icon(Icons.add),
            label: const Text("Add Question"),
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
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Quiz Title",
                      labelStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                    validator: (val) {
                      if (val!.isEmpty) return "Enter Quiz Title";
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(height: SizeService(context).verticalPadding),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.text,
                    minLines: 3,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: "Quiz Description",
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) return "Enter Quiz Description";
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(height: SizeService(context).verticalPadding),
                Text(
                  "Questions",
                  style: GoogleFonts.exo2(
                    fontSize: 18.0,
                  ),
                ),
                const Divider(
                  color: Colors.black54,
                ),
                QuestionsBuilder(quiz: widget.quiz),
                ElevatedButton(
                  onPressed: onSubmit,
                  child: const Text("Update"),
                ),
              ],
            ),
          )),
    );
  }
}
