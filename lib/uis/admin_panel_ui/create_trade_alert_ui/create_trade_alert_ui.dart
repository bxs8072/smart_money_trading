import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:smart_money_trading/models/ticker.dart';
import 'package:smart_money_trading/models/trade_alert.dart';
import 'package:smart_money_trading/services/stocks_global.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:smart_money_trading/custom_widgets/custom_card.dart';

class CreateTradeAlertUI extends StatefulWidget {
  const CreateTradeAlertUI({super.key});

  @override
  State<CreateTradeAlertUI> createState() => _CreateTradeAlertUIState();
}

class _CreateTradeAlertUIState extends State<CreateTradeAlertUI> {
  TextEditingController totalCostController = TextEditingController();
  TextEditingController pnlController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<TextEditingController> strikePriceControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  String selectedOptionStrategy = optyionTypeList.first;
  Ticker selectedTicker = stockTickerList.first;

  int totalCost = 0;
  String optionType = "buy";
  DateTime datetime = DateTime.now();

  @override
  void dispose() {
    totalCostController.dispose();
    pnlController.dispose();
    descriptionController.dispose();
    for (TextEditingController controller in strikePriceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

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
                "Create Trade Alert",
                key: widget.key,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Select Ticker",
                        key: widget.key,
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    CustomCard(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 0.0,
                        vertical: 3.0,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<Ticker>(
                        isExpanded: true,
                        key: widget.key,
                        borderRadius: BorderRadius.circular(12.0),
                        underline: const Center(),
                        items: stockTickerList
                            .map(
                              (object) => DropdownMenuItem(
                                key: Key(object.title),
                                value: object,
                                child: Text(
                                  object.title.toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (object) =>
                            setState(() => selectedTicker = object!),
                        value: selectedTicker,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Select Option Strategy",
                        key: widget.key,
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontWeight: FontWeight.w600),
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
                        value: selectedOptionStrategy,
                        items: optyionTypeList
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Select Option Type",
                        key: widget.key,
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontWeight: FontWeight.w600),
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
                        value: optionType,
                        items: ["buy", "sell"]
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
                            optionType = val!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomCard(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 0.0,
                        vertical: 3.0,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: totalCostController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Total Cost",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomCard(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 0.0,
                        vertical: 3.0,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: pnlController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "P&L Amount",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: strikePriceControllers
                          .map(
                            (strikePriceController) => CustomCard(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 0.0,
                                vertical: 3.0,
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                controller: strikePriceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText:
                                      "Strike Price ${strikePriceControllers.indexOf(strikePriceController) + 1}",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    CustomCard(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 0.0,
                        vertical: 3.0,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: descriptionController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Closed Description",
                          border: InputBorder.none,
                        ),
                        maxLines: 15,
                        minLines: 10,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomCard(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 0.0,
                        vertical: 3.0,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        readOnly: true,
                        enabled: true,
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 5),
                            currentDate: datetime,
                            initialDatePickerMode: DatePickerMode.day,
                          ).then((date) {
                            showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                .then((value) {
                              setState(() {
                                datetime = DateTime(date!.year, date.month,
                                    date.day, value!.hour, value.minute);
                              });
                            });
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.calendar_month,
                            color: ThemeService.secondary,
                          ),
                          hintText: Intl().date().format(datetime),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection("tradeAlerts")
                            .doc()
                            .set(
                              TradeAlert(
                                ticker: selectedTicker,
                                isClosed: true,
                                strategy: selectedOptionStrategy,
                                description: descriptionController.text.trim(),
                                prices: strikePriceControllers
                                    .map((e) => double.parse(
                                          e.text.trim(),
                                        ))
                                    .toList(),
                                datetime: Timestamp.fromDate(datetime),
                                totalCost: double.parse(
                                    totalCostController.text.trim()),
                                pnl: double.parse(pnlController.text.trim()),
                                optionType: optionType,
                                docId: "",
                                createdAt: Timestamp.now(),
                                alertType: "TRADE_ALERT",
                              ).toJson,
                            )
                            .then((value) => Navigator.pop(context),);
                      },
                      child: const Text("CREATE TRADE ALERT"),
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
