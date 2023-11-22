import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_money_trading/models/education_material.dart';
import 'package:smart_money_trading/services/size_service.dart';

class AddEducationMaterialUI extends StatefulWidget {
  const AddEducationMaterialUI({super.key});

  @override
  State<AddEducationMaterialUI> createState() => _AddEducationMaterialUIState();
}

class _AddEducationMaterialUIState extends State<AddEducationMaterialUI> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController pdfUrlController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> onSubmit() async {
    if (formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection("educationMaterials")
          .doc()
          .set({
        "title": titleController.text.trim(),
        "subtitle": subtitleController.text.trim(),
        "imageUrl": imageUrlController.text.trim(),
        "pdfUrl": pdfUrlController.text.trim(),
        "updatedAt": Timestamp.now(),
        "createdAt": Timestamp.now(),
      }).then((value) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Education Material"),
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
                  labelText: "Title",
                  labelStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
                validator: (val) {
                  if (val!.isEmpty) return "Enter Education Material Title";
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
                controller: subtitleController,
                keyboardType: TextInputType.text,
                minLines: 3,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: "Subtitle",
                  labelStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
                validator: (val) {
                  if (val!.isEmpty) return "Enter Education Material Subtitle";
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
                controller: imageUrlController,
                keyboardType: TextInputType.text,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Image Url",
                  labelStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
                validator: (val) {
                  if (val!.isEmpty) return "Enter Education Image Url";
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
                controller: pdfUrlController,
                keyboardType: TextInputType.text,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Pdf Url",
                  labelStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
                validator: (val) {
                  if (val!.isEmpty) return "Enter Education Material Pdf Url";
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
              child: const Text("Add Education Material"),
            ),
          ],
        ),
      ),
    );
  }
}
