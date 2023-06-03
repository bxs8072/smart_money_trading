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

  String type = "daily";

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
                        controller: descriptionController,
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
                    CustomCard(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 0.0,
                        vertical: 3.0,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<String>(
                        borderRadius: BorderRadius.circular(12.0),
                        underline: const Center(),
                        isExpanded: true,
                        key: widget.key,
                        value: type,
                        items: ["daily", "weekly"]
                            .map(
                              (e) => DropdownMenuItem<String>(
                                key: Key(e),
                                value: e,
                                child: Text(
                                  e.toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            type = val!;
                          });
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
                                      type: type,
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
