import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_money_trading/models/address.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({
    super.key,
  });

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
                    "Account Registration",
                    key: widget.key,
                    style: GoogleFonts.baskervville(
                      fontSize: SizeService(context).height * 0.030,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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
                                hintText: "John",
                                labelText: "First Name",
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black54,
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
                              controller: middlenameController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: "M",
                                labelText: "Middle Name",
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black54,
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
                              controller: lastnameController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: "Cena",
                                labelText: "Last Name",
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black54,
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
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                hintText: "(###) ### - ####",
                                labelText: "Phone",
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black54,
                                  ),
                                ),
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
                                hintText: "124 Main St",
                                labelText: "Address",
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black54,
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
                              controller: line2Controller,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: "Apt 117",
                                labelText: "Address 2 (Optional)",
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black54,
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
                              controller: cityController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: "Arlington",
                                labelText: "City",
                                labelStyle: TextStyle(color: Colors.black),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black54,
                                  ),
                                ),
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
                                      hintText: "Texas",
                                      labelText: "State",
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black54,
                                        ),
                                      ),
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
                                      hintText: "19920",
                                      labelText: "Postal Code",
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: SizeService(context).verticalPadding),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              elevation: 25,
                            ),
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
                                "dateOfBirth": Timestamp.fromDate(dateOfBirth),
                                "address": Address(
                                  line1: line1Controller.text.trim(),
                                  line2: line2Controller.text.trim(),
                                  city: cityController.text.trim(),
                                  state: stateController.text.trim(),
                                  zipcode: zipcodeController.text.trim(),
                                ).toJson,
                              });
                            },
                            child: Text(
                              "Create Account",
                              key: widget.key,
                              style: GoogleFonts.baskervville(
                                fontSize: SizeService(context).height * 0.025,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
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
