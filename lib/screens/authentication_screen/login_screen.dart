import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeService(context).height * 0.040,
              vertical: SizeService(context).height * 0.020,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              key: widget.key,
              children: [
                Image.asset(
                  "assets/oxt_logo.png",
                  height: 150,
                  alignment: Alignment.topCenter,
                ),

                SizedBox(
                  height: SizeService(context).verticalPadding * 1.0,
                ),
                Text(
                  "Enhancing Trading Decisions",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.baskervville(
                    fontSize: SizeService(context).height * 0.025,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: SizeService(context).verticalPadding * 1.0),
                Text(
                  "Sign in",
                  style: GoogleFonts.baskervville(
                    fontSize: SizeService(context).height * 0.035,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                // SizedBox(height: SizeService(context).verticalPadding * 1.0),
                Form(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeService(context).height * 0.001,
                      vertical: SizeService(context).height * 0.020,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "abcd@email.com",
                            labelText: "Email Address",
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Colors.black54,
                            ),
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
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            hintText: "********",
                            labelText: "Password",
                            labelStyle: const TextStyle(color: Colors.black),
                            prefixIcon: const Icon(
                              Icons.password_outlined,
                              color: Colors.black54,
                            ),
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
                          child: Text(
                            "Forgot password?",
                            key: widget.key,
                            style: GoogleFonts.baskervville(
                              fontSize: SizeService(context).height * 0.020,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            elevation: 25,
                          ),
                          onPressed: () {
                            FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: emailController.text
                                        .trim()
                                        .toLowerCase(),
                                    password: passwordController.text.trim())
                                .catchError((error) {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return ErrorDialog(
                                      message:
                                          error.toString().split("]")[1].trim(),
                                      title: "Login Error",
                                    );
                                  });
                            });
                          },
                          child: Text(
                            "Login",
                            key: widget.key,
                            style: GoogleFonts.baskervville(
                              fontSize: SizeService(context).height * 0.025,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeService(context).verticalPadding,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              key: widget.key,
                              style: GoogleFonts.baskervville(
                                fontSize: SizeService(context).height * 0.020,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                widget.bloc.update(FormType.register);
                              },
                              child: Text(
                                "Sign up",
                                style: GoogleFonts.baskervville(
                                  fontSize: SizeService(context).height * 0.025,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
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
        ),
      ],
    );
  }
}
