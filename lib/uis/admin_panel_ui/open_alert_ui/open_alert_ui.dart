import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_money_trading/models/open_alert.dart';
import 'package:smart_money_trading/models/ticker.dart';
import 'package:smart_money_trading/services/stocks_global.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';

class OpenAlertUI extends StatefulWidget {
  const OpenAlertUI({super.key});

  @override
  State<OpenAlertUI> createState() => _OpenAlertUIState();
}

class _OpenAlertUIState extends State<OpenAlertUI> {
  Ticker selectedTicker = stockTickerList[0];
  DateTime datetime = DateTime.now();
  TextEditingController strategyDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      body: CustomScrollView(
        key: widget.key,
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(
              "Create Open Alert",
              key: widget.key,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Select Ticker",
                    key: widget.key,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: ThemeService(context).isDark
                          ? Colors.black12
                          : Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 0.1,
                          blurRadius: 0.0,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: DropdownButton<Ticker>(
                      borderRadius: BorderRadius.circular(12.0),
                      dropdownColor: ThemeService(context).isDark
                          ? Colors.black12
                          : Colors.white,
                      underline: const Center(),
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
                    "Opened Datetime",
                    key: widget.key,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: ThemeService(context).isDark
                          ? Colors.black12
                          : Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 0.1,
                          blurRadius: 0.0,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: TextField(
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeService(context).isDark
                          ? Colors.black12
                          : Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 0.1,
                          blurRadius: 0.0,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: strategyDescriptionController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "Strategy Description",
                        border: InputBorder.none,
                      ),
                      maxLines: 15,
                      minLines: 10,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection("optionAlerts")
                          .doc()
                          .set(OpenAlert(
                            ticker: selectedTicker,
                            type: "opened",
                            description:
                                strategyDescriptionController.text.trim(),
                            createdAt: Timestamp.now(),
                            datetime: Timestamp.fromDate(datetime),
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
    );
  }
}
