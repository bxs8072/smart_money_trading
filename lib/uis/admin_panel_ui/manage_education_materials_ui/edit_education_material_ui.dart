import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_money_trading/models/education_material.dart';
import 'package:smart_money_trading/services/size_service.dart';

class EditEducationMaterialUI extends StatefulWidget {
  final EducationMaterial educationMaterial;
  const EditEducationMaterialUI({super.key, required this.educationMaterial});

  @override
  State<EditEducationMaterialUI> createState() =>
      _EditEducationMaterialUIState();
}

class _EditEducationMaterialUIState extends State<EditEducationMaterialUI> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController pdfUrlController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> onSubmit() async {
    if (formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection("educationMaterials")
          .doc(widget.educationMaterial.docId)
          .update({
        "title": titleController.text.trim(),
        "subtitle": subtitleController.text.trim(),
        "imageUrl": imageUrlController.text.trim(),
        "pdfUrl": pdfUrlController.text.trim(),
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
    titleController.text = widget.educationMaterial.title;
    subtitleController.text = widget.educationMaterial.subtitle;
    imageUrlController.text = widget.educationMaterial.imageUrl;
    pdfUrlController.text = widget.educationMaterial.pdfUrl;
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
              child: const Text("Update Education Material"),
            ),
          ],
        ),
      ),
    );
  }
}
