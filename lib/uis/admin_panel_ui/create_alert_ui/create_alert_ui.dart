import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_money_trading/models/ticker.dart';
import 'package:smart_money_trading/models/ticker_notification.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/services/stocks_global.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';

class CreateAlertUI extends StatefulWidget {
  const CreateAlertUI({super.key});

  @override
  State<CreateAlertUI> createState() => _CreateAlertUIState();
}

class _CreateAlertUIState extends State<CreateAlertUI> {
  TextEditingController totalCostController = TextEditingController();
  TextEditingController strategyDescriptionController = TextEditingController();

  List<TextEditingController> strikePriceControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void dispose() {
    totalCostController.dispose();
    strategyDescriptionController.dispose();
    for (TextEditingController controller in strikePriceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  int totalCost = 0;
  String selectedOptionStrategy = optyionTypeList[0];
  String optionType = "buy";
  Ticker selectedTicker = stockTickerList[0];
  DateTime expiresAt = DateTime.now();

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
                      elevation: 1.0,
                      child: DropdownButton<Ticker>(
                        borderRadius: BorderRadius.circular(12.0),
                        underline: const Center(),
                        elevation: 1,
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
                                  child: Text(e.title.toUpperCase()),
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
                      elevation: 1.0,
                      child: DropdownButton<String>(
                        borderRadius: BorderRadius.circular(12.0),
                        underline: const Center(),
                        elevation: 1,
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
                      elevation: 1.0,
                      child: DropdownButton<String>(
                        borderRadius: BorderRadius.circular(12.0),
                        underline: const Center(),
                        elevation: 1,
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
                    const SizedBox(height: 10),
                    SizedBox(
                      key: widget.key,
                      height: SizeService(context).height * 0.07,
                      child: TextFormField(
                        controller: totalCostController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Total Cost",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
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
                    TextFormField(
                      readOnly: true,
                      enabled: true,
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 5),
                          currentDate: expiresAt,
                          initialDatePickerMode: DatePickerMode.day,
                        ).then((date) {
                          showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                              .then((value) {
                            setState(() {
                              expiresAt = DateTime(date!.year, date.month,
                                  date.day, value!.hour, value.minute);
                            });
                          });
                        });
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        disabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: ThemeService.secondary),
                        ),
                        prefixIcon: const Icon(
                          Icons.calendar_month,
                          color: ThemeService.secondary,
                        ),
                        hintText: Intl().date().format(expiresAt),
                      ),
                    ),
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
                              expiresAt: Timestamp.fromDate(expiresAt),
                              totalCost:
                                  double.parse(totalCostController.text.trim()),
                              optionType: optionType,
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
