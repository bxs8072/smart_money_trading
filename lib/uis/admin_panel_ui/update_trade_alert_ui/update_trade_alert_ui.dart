import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_money_trading/models/ticker.dart';
import 'package:smart_money_trading/models/close_alert.dart';
import 'package:smart_money_trading/models/trade_alert.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/services/stocks_global.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';

class UpdateTradeAlertUI extends StatefulWidget {
  final TradeAlert tradeAlert;
  const UpdateTradeAlertUI({super.key, required this.tradeAlert});

  @override
  State<UpdateTradeAlertUI> createState() => _UpdateTradeAlertUIState();
}

class _UpdateTradeAlertUIState extends State<UpdateTradeAlertUI> {
  TextEditingController totalCostController = TextEditingController();
  TextEditingController pnlController = TextEditingController();
  TextEditingController closedDescriptionController = TextEditingController();

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
  DateTime closedDate = DateTime.now();

  @override
  void dispose() {
    totalCostController.dispose();
    pnlController.dispose();
    closedDescriptionController.dispose();
    for (TextEditingController controller in strikePriceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      stockTickerList.first = widget.tradeAlert.ticker;
      selectedTicker = stockTickerList.first;
    });
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Select Ticker",
                        key: widget.key,
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeService(context).isDark
                            ? Colors.black12
                            : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 0.0,
                            blurRadius: 0.05,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeService(context).isDark
                            ? Colors.black12
                            : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 0.0,
                            blurRadius: 0.05,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeService(context).isDark
                            ? Colors.black12
                            : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 0.0,
                            blurRadius: 0.05,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeService(context).isDark
                            ? Colors.black12
                            : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 0.0,
                            blurRadius: 0.05,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeService(context).isDark
                            ? Colors.black12
                            : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 0.0,
                            blurRadius: 0.05,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
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
                            (strikePriceController) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: ThemeService(context).isDark
                                    ? Colors.black12
                                    : Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 0.0,
                                    blurRadius: 0.05,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeService(context).isDark
                            ? Colors.black12
                            : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 0.0,
                            blurRadius: 0.05,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: closedDescriptionController,
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeService(context).isDark
                            ? Colors.black12
                            : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 0.0,
                            blurRadius: 0.05,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        readOnly: true,
                        enabled: true,
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 5),
                            currentDate: closedDate,
                            initialDatePickerMode: DatePickerMode.day,
                          ).then((date) {
                            showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                .then((value) {
                              setState(() {
                                closedDate = DateTime(date!.year, date.month,
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
                          hintText: Intl().date().format(closedDate),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection("optionAlerts")
                            .doc(widget.tradeAlert.docId)
                            .update(TradeAlert(
                              ticker: selectedTicker,
                              isClosed: true,
                              strategy: selectedOptionStrategy,
                              closedDescription:
                                  closedDescriptionController.text.trim(),
                              prices: strikePriceControllers
                                  .map((e) => double.parse(
                                        e.text.trim(),
                                      ))
                                  .toList(),
                              openedAt: widget.tradeAlert.openedAt,
                              closedAt: Timestamp.fromDate(closedDate),
                              totalCost:
                                  double.parse(totalCostController.text.trim()),
                              pnl: double.parse(pnlController.text.trim()),
                              optionType: optionType,
                              docId: widget.tradeAlert.docId,
                              openedDescription:
                                  widget.tradeAlert.openedDescription,
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
