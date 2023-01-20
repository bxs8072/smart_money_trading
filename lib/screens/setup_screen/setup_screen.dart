import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController middlenameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController line1Controller = TextEditingController();
  TextEditingController line2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();

  @override
  void dispose() {
    firstnameController.dispose();
    middlenameController.dispose();
    lastnameController.dispose();
    phoneController.dispose();
    line1Controller.dispose();
    line2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    zipcodeController.dispose();
    super.dispose();
  }

  DateTime dateOfBirth = DateTime(2003, 1, 1);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
      child: Scaffold(
        key: widget.key,
        body: CustomScrollView(
          key: widget.key,
          slivers: [
            SliverAppBar(
              key: widget.key,
              leading: null,
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  color: ThemeService.primary,
                  icon: const Icon(Icons.logout_outlined),
                ),
              ],
            ),
            SliverToBoxAdapter(
              key: widget.key,
              child: Column(
                key: widget.key,
                children: [
                  Text(
                    "SETUP ACCOUNT",
                    key: widget.key,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.035,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: SizeService(context).verticalPadding * 1.5),
                  Form(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              SizeService(context).horizontalPadding * 0.6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            key: widget.key,
                            height: SizeService(context).height * 0.07,
                            child: TextFormField(
                              controller: firstnameController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "John",
                                labelText: "First Name",
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          SizedBox(
                            key: widget.key,
                            height: SizeService(context).height * 0.07,
                            child: TextFormField(
                              controller: middlenameController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "M",
                                labelText: "Middle Name",
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          SizedBox(
                            key: widget.key,
                            height: SizeService(context).height * 0.07,
                            child: TextFormField(
                              controller: lastnameController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Cena",
                                labelText: "Last Name",
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          SizedBox(
                            key: widget.key,
                            height: SizeService(context).height * 0.07,
                            child: TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "(###) ### - ####",
                                labelText: "Phone",
                              ),
                              inputFormatters: [
                                PhoneInputFormatter(
                                  defaultCountryCode: "US",
                                  allowEndlessPhone: false,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 7),
                          GestureDetector(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: dateOfBirth,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2004),
                                currentDate: dateOfBirth,
                                initialDatePickerMode: DatePickerMode.year,
                              ).then((value) {
                                setState(() {
                                  dateOfBirth = value!;
                                });
                              });
                            },
                            child: SizedBox(
                              key: widget.key,
                              height: SizeService(context).height * 0.07,
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ThemeService.secondary),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.calendar_month,
                                    color: ThemeService.secondary,
                                  ),
                                  labelText: Intl()
                                      .date("MM.dd.yyyy")
                                      .format(dateOfBirth),
                                  labelStyle: const TextStyle(
                                    color: ThemeService.secondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          SizedBox(
                            key: widget.key,
                            height: SizeService(context).height * 0.07,
                            child: TextFormField(
                              controller: line1Controller,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "124 Main St",
                                labelText: "Address",
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          SizedBox(
                            key: widget.key,
                            height: SizeService(context).height * 0.07,
                            child: TextFormField(
                              controller: line2Controller,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Apt 117",
                                labelText: "Address 2 (Optional)",
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          SizedBox(
                            key: widget.key,
                            height: SizeService(context).height * 0.07,
                            child: TextFormField(
                              controller: cityController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Arlington",
                                labelText: "City",
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  key: widget.key,
                                  height: SizeService(context).height * 0.07,
                                  child: TextFormField(
                                    controller: stateController,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Texas",
                                      labelText: "State",
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SizedBox(
                                  key: widget.key,
                                  height: SizeService(context).height * 0.07,
                                  child: TextFormField(
                                    controller: zipcodeController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "19920",
                                      labelText: "Postal Code",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: SizeService(context).verticalPadding),
                          ElevatedButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('customers')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                "setup": true,
                                "firstname": firstnameController.text.trim(),
                                "middlename": middlenameController.text.trim(),
                                "lastname": lastnameController.text.trim(),
                                "phone": phoneController.text.trim(),
                                "line1": line1Controller.text.trim(),
                                "line2": line2Controller.text.trim(),
                                "dateOfBirth": Timestamp.fromDate(dateOfBirth),
                                "city": cityController.text.trim(),
                                "state": stateController.text.trim(),
                                "zipcode": zipcodeController.text.trim(),
                              });
                            },
                            child: Text("CREATE ACCOUNT", key: widget.key),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
