import 'package:flutter/material.dart';
import 'package:smart_money_trading/screens/authentication_screen/authentication_screen_bloc.dart';
import 'package:smart_money_trading/screens/authentication_screen/forget_password_screen.dart';
import 'package:smart_money_trading/screens/authentication_screen/login_screen.dart';
import 'package:smart_money_trading/screens/authentication_screen/register_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final AuthenticationScreenBloc bloc = AuthenticationScreenBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
        child: StreamBuilder<FormType>(
          stream: bloc.stream,
          initialData: FormType.login,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case FormType.register:
                return RegisterScreen(bloc: bloc);
              case FormType.forgetPassword:
                return ForgetPasswordScreen(bloc: bloc);
              default:
                return LoginScreen(bloc: bloc);
            }
          },
        ),
      ),
    );
  }
}
