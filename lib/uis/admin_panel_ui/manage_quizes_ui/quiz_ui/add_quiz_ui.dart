import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_money_trading/services/size_service.dart';

class AddQuizUI extends StatefulWidget {
  const AddQuizUI({super.key});

  @override
  State<AddQuizUI> createState() => _AddQuizUIState();
}

class _AddQuizUIState extends State<AddQuizUI> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> onSubmit() async {
    if (formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection("quizes").doc().set({
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "createdAt": Timestamp.now(),
        "updatedAt": Timestamp.now(),
      }).then((value) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Creating Quiz"),
          ),
          body: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
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
                    maxLines: 5,
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
                ElevatedButton(
                  onPressed: onSubmit,
                  child: const Text("Submit"),
                ),
              ],
            ),
          )),
    );
  }
}
