import 'package:flutter/material.dart';

class NavigationService {
  final BuildContext context;
  NavigationService(this.context);

  void push(Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return widget;
        },
      ),
    );
  }

  void pushAndReplace(Widget widget) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return widget;
        },
      ),
    );
  }
}
