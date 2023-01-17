import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_money_trading/custom_widgets/error_dialog.dart';
import 'package:smart_money_trading/screens/authentication_screen/authentication_screen_bloc.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';

class LoginScreen extends StatefulWidget {
  final AuthenticationScreenBloc bloc;
  const LoginScreen({super.key, required this.bloc});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isVisiblePassword = false;

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
                "SIGN IN",
                key: widget.key,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.05,
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
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: isVisiblePassword,
                        decoration: InputDecoration(
                          hintText: "********",
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisiblePassword = !isVisiblePassword;
                              });
                            },
                            color: isVisiblePassword
                                ? ThemeService.success
                                : ThemeService.secondary,
                            icon: Icon(isVisiblePassword
                                ? Icons.remove_red_eye
                                : Icons.remove_red_eye_outlined),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),
                      SizedBox(height: SizeService(context).verticalPadding),
                      TextButton(
                        onPressed: () {
                          widget.bloc.update(FormType.forgetPassword);
                        },
                        child: Text("Forget Password?", key: widget.key),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email:
                                      emailController.text.trim().toLowerCase(),
                                  password: passwordController.text.trim())
                              .catchError((error) {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return ErrorDialog(
                                    message: error.toString().split("]")[1],
                                    title: "Login Error",
                                  );
                                });
                          });
                        },
                        child: Text("LOGIN", key: widget.key),
                      ),
                      SizedBox(
                        height: SizeService(context).verticalPadding,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Need an account? ",
                            key: widget.key,
                          ),
                          TextButton(
                            onPressed: () {
                              widget.bloc.update(FormType.register);
                            },
                            child: const Text("SIGN UP"),
                          ),
                        ],
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
