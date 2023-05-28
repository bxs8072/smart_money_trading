import 'package:flutter/material.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;
  const CustomCard({
    super.key,
    required this.child,
    required this.margin,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: ThemeService(context).isDark ? Colors.black12 : Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.0),
            spreadRadius: 0.0,
            blurRadius: 0.0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: child,
    );
  }
}
