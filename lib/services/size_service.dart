import 'package:flutter/material.dart';

class SizeService {
  final BuildContext context;
  SizeService(this.context);

  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;

  double get horizontalPadding => width * 0.1;
  double get verticalPadding => height * 0.02;
}
