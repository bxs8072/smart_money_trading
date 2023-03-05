import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_money_trading/models/ticker.dart';
import 'package:smart_money_trading/models/ticker_notification.dart';
import 'package:smart_money_trading/services/stocks_global.dart';

class CreateAlertUI extends StatefulWidget {
  const CreateAlertUI({super.key});

  @override
  State<CreateAlertUI> createState() => _CreateAlertUIState();
}

class _CreateAlertUIState extends State<CreateAlertUI> {
  Ticker selectedTicker = stockTickerList[0];

  String selectedOptionStrategy = optyionTypeList[0];

  String optionType = "buy";
  List<TextEditingController> strikePriceControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  TextEditingController strategyDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: Text(
                "Create Alert",
                key: widget.key,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Select Ticker",
                      key: widget.key,
                      textAlign: TextAlign.center,
                    ),
                    Card(
                      elevation: 6.0,
                      child: DropdownButton<Ticker>(
                        borderRadius: BorderRadius.circular(12.0),
                        underline: const Center(),
                        elevation: 6,
                        hint: const Text("Select Ticker"),
                        isExpanded: true,
                        key: widget.key,
                        value: selectedTicker,
                        items: stockTickerList
                            .map(
                              (e) => DropdownMenuItem<Ticker>(
                                key: Key(e.title),
                                value: e,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        maxRadius: 10,
                                        backgroundImage: AssetImage(e.image),
                                      ),
                                      const SizedBox(width: 20),
                                      Text(e.title.toUpperCase()),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedTicker = val!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Select Option Strategy",
                      key: widget.key,
                      textAlign: TextAlign.center,
                    ),
                    Card(
                      elevation: 6.0,
                      child: DropdownButton<String>(
                        borderRadius: BorderRadius.circular(12.0),
                        underline: const Center(),
                        elevation: 6,
                        hint: const Text("Select Option Strategy"),
                        isExpanded: true,
                        key: widget.key,
                        value: selectedOptionStrategy,
                        items: optyionTypeList
                            .map(
                              (e) => DropdownMenuItem<String>(
                                key: Key(e),
                                value: e,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(e.toUpperCase())),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          List<String> optyionTypeLists = [
                            "butterfly",
                            "call spread",
                            "condor",
                            "iron butterfly",
                            "iron condor",
                            "outright call",
                            "outright put",
                            "put spread",
                          ];

                          setState(() {
                            selectedOptionStrategy = val!;
                            if (val == "call spread" || val == "put spread") {
                              strikePriceControllers = [
                                TextEditingController(),
                                TextEditingController()
                              ];
                            }

                            if (val == "butterfly" ||
                                val == "condor" ||
                                val == "iron condor" ||
                                val == "iron butterfly") {
                              strikePriceControllers = [
                                TextEditingController(),
                                TextEditingController(),
                                TextEditingController(),
                                TextEditingController(),
                              ];
                            }

                            if (val == "outright call" ||
                                val == "outright put") {
                              strikePriceControllers = [
                                TextEditingController()
                              ];
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Select Option Type",
                      key: widget.key,
                      textAlign: TextAlign.center,
                    ),
                    Card(
                      elevation: 6.0,
                      child: DropdownButton<String>(
                        borderRadius: BorderRadius.circular(12.0),
                        underline: const Center(),
                        elevation: 6,
                        hint: const Text("Select Option Type"),
                        isExpanded: true,
                        key: widget.key,
                        value: optionType,
                        items: ["buy", "sell"]
                            .map(
                              (e) => DropdownMenuItem<String>(
                                key: Key(e),
                                value: e,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(e.toUpperCase())),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            optionType = val!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: strikePriceControllers
                          .map(
                            (strikePriceController) => Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: TextFormField(
                                controller: strikePriceController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Strike Price",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: strategyDescriptionController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Strategy Description",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 8,
                      minLines: 4,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        FirebaseFirestore.instance
                            .collection("optionAlerts")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("optionAlerts")
                            .doc()
                            .set(TickerNotification(
                              ticker: selectedTicker,
                              strategy: selectedOptionStrategy,
                              description:
                                  strategyDescriptionController.text.trim(),
                              prices: strikePriceControllers
                                  .map((e) => double.parse(
                                        e.text.trim(),
                                      ))
                                  .toList(),
                              createdAt: Timestamp.now(),
                            ).toJson)
                            .then((value) => Navigator.pop(context));
                      },
                      child: const Text("SUBMIT"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
