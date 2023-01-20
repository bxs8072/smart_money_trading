import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_money_trading/custom_widgets/error_dialog.dart';
import 'package:smart_money_trading/screens/authentication_screen/authentication_screen_bloc.dart';
import 'package:smart_money_trading/services/size_service.dart';

class ForgetPasswordScreen extends StatefulWidget {
  final AuthenticationScreenBloc bloc;
  const ForgetPasswordScreen({super.key, required this.bloc});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: widget.key,
      slivers: [
        SliverAppBar(
          key: widget.key,
          leading: null,
          backgroundColor: Colors.transparent,
        ),
        SliverToBoxAdapter(
          key: widget.key,
          child: Column(
            key: widget.key,
            children: [
              Text(
                "FORGET PASSWORD",
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
                      horizontal: SizeService(context).horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "abcd@email.com",
                          labelText: "Email Address",
                          prefixIcon: Icon(Icons.email),
                        ),
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),
                      SizedBox(height: SizeService(context).verticalPadding),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseAuth.instance
                              .sendPasswordResetEmail(
                                  email:
                                      emailController.text.trim().toLowerCase())
                              .catchError((error) {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return ErrorDialog(
                                    message:
                                        error.toString().split("]")[1].trim(),
                                    title: "Error",
                                  );
                                });
                          });
                        },
                        child: Text("SEND RESET EMAIL", key: widget.key),
                      ),
                      SizedBox(
                        height: SizeService(context).height * 0.3,
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          widget.bloc.update(FormType.login);
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("SIGN IN"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
