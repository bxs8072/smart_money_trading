import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_money_trading/custom_widgets/custom_card.dart';
import 'package:smart_money_trading/models/insight_alert.dart';

class CreateInsightAlertUI extends StatefulWidget {
  const CreateInsightAlertUI({super.key});

  @override
  State<CreateInsightAlertUI> createState() => _CreateInsightAlertUIState();
}

class _CreateInsightAlertUIState extends State<CreateInsightAlertUI> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(
              "Create Insight Alert",
              key: widget.key,
            ),
          ),
          SliverToBoxAdapter(
            child: Form(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    CustomCard(
                      margin: const EdgeInsets.symmetric(
                        vertical: 3.0,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: "Title",
                        ),
                        validator: (val) {
                          if (val!.isEmpty) return "Please enter title";
                          return null;
                        },
                      ),
                    ),
                    CustomCard(
                      margin: const EdgeInsets.symmetric(
                        vertical: 3.0,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: "Description",
                        ),
                        minLines: 10,
                        maxLines: 15,
                        validator: (val) {
                          if (val!.isEmpty) return "Please enter title";
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("insights")
                              .doc()
                              .set(InsightAlert(
                                      title: titleController.text.trim(),
                                      type: "daily",
                                      description:
                                          descriptionController.text.trim(),
                                      datetime: Timestamp.now(),
                                      createdAt: Timestamp.now())
                                  .toJson)
                              .then((value) => Navigator.pop(context));
                        },
                        child: const Text("Submit")),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
