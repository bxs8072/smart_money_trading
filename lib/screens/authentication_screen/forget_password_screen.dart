import 'package:flutter/material.dart';
import 'package:smart_money_trading/screens/authentication_screen/authentication_screen_bloc.dart';

class ForgetPasswordScreen extends StatefulWidget {
  final AuthenticationScreenBloc bloc;
  const ForgetPasswordScreen({super.key, required this.bloc});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: widget.key,
      slivers: [
        SliverAppBar(
          key: widget.key,
          leading: null,
        )
      ],
    );
  }
}
