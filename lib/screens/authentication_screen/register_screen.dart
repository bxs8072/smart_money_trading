import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_money_trading/custom_widgets/error_dialog.dart';
import 'package:smart_money_trading/screens/authentication_screen/authentication_screen_bloc.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';

class RegisterScreen extends StatefulWidget {
  final AuthenticationScreenBloc bloc;
  const RegisterScreen({super.key, required this.bloc});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool isVisiblePassword = false;
  bool isValidPassword = false;
  bool isTermAndConditionAccepted = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              key: widget.key,
              children: [
                Text(
                  "Welcome to\nSmart Money Trading,",
                  // textAlign: TextAlign.start,
                  style: GoogleFonts.baskervville(
                    fontSize: SizeService(context).height * 0.035,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: SizeService(context).verticalPadding * .5),
                Text(
                  "Navigating Markets with Precision and Insight",
                  // textAlign: TextAlign.start,
                  style: GoogleFonts.baskervville(
                    fontSize: SizeService(context).height * 0.025,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: SizeService(context).verticalPadding * 2.0),
                Text(
                  "Register to continue.",
                  style: GoogleFonts.baskervville(
                    fontSize: SizeService(context).height * 0.030,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: SizeService(context).verticalPadding * 1.5),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeService(context).height * 0.010,
                      vertical: SizeService(context).height * 0.010,
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
                          validator: (val) {
                            if (!EmailValidator.validate(val!)) {
                              return "Enter valid email address";
                            }
                            return null;
                          },
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
                          validator: (val) {
                            if (isValidPassword == false) {
                              return "Enter valid password";
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {});
                          },
                        ),
                        SizedBox(height: SizeService(context).height * 0.02),
                        FlutterPwValidator(
                          controller: passwordController,
                          minLength: 6,
                          uppercaseCharCount: 1,
                          numericCharCount: 2,
                          specialCharCount: 1,
                          width: 400,
                          height: 150,
                          onSuccess: () {
                            setState(() {
                              isValidPassword = true;
                            });
                          },
                          onFail: () {
                            setState(() {
                              isValidPassword = false;
                            });
                          },
                        ),
                        SizedBox(height: SizeService(context).verticalPadding),
                        TextFormField(
                          controller: confirmPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black54,
                              ),
                            ),
                            hintText: "********",
                            labelText: "Confirm Password",
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(
                              Icons.password_outlined,
                              color: Colors.black54,
                            ),
                          ),
                          validator: (val) {
                            if (val != passwordController.text) {
                              return "Password did not match.";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: SizeService(context).verticalPadding),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                                activeColor: ThemeService.success,
                                checkColor: ThemeService.light,
                                value: isTermAndConditionAccepted,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                onChanged: (val) {
                                  setState(() {
                                    isTermAndConditionAccepted = val!;
                                  });
                                }),
                            Text(
                              "Please accept our",
                              key: widget.key,
                              style: const TextStyle(color: Colors.black),
                            ),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        title:
                                            const Text("Terms and Conditions"),
                                        content: const Text(
                                            "Random TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom TextRandom Text"),
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                isTermAndConditionAccepted =
                                                    true;
                                              });
                                              Navigator.pop(ctx);
                                            },
                                            style: OutlinedButton.styleFrom(
                                                foregroundColor:
                                                    ThemeService.light,
                                                backgroundColor:
                                                    ThemeService.success),
                                            child: const Text("ACCEPT"),
                                          ),
                                          OutlinedButton(
                                            onPressed: () {
                                              setState(() {
                                                isTermAndConditionAccepted =
                                                    false;
                                              });
                                              Navigator.pop(ctx);
                                            },
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor:
                                                  ThemeService.error,
                                            ),
                                            child: const Text("DENY"),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Text(
                                "Terms & Conditions",
                                style: GoogleFonts.baskervville(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            elevation: 25,
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate() &&
                                isTermAndConditionAccepted) {
                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: emailController.text
                                          .trim()
                                          .toLowerCase(),
                                      password: passwordController.text.trim())
                                  .catchError((error) {
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return ErrorDialog(
                                        message: error
                                            .toString()
                                            .split("]")[1]
                                            .trim(),
                                        title: "Sign Up Error",
                                      );
                                    });
                              });
                            }
                          },
                          child: Text(
                            "Register",
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
                              "Already have an account? ",
                              key: widget.key,
                            ),
                            TextButton(
                              onPressed: () {
                                widget.bloc.update(FormType.login);
                              },
                              child: Text(
                                "Sing in",
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
