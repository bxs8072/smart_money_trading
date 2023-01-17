import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class ThemeService {
  static const String lightId = "light";
  static const String darkId = "dark";

  static const Color primary = Color(0xFF006DFE);
  static const Color secondary = Color(0xFF606A72);
  static const Color error = Color(0xFFDE233D);
  static const Color success = Color(0xFF089F3D);
  static const Color warning = Color(0xFFFFB914);
  static const Color info = Color(0xFF0099AF);
  static const Color light = Color(0xFFF7F8F9);
  static const Color dark = Color(0xFF2D3338);

  final BuildContext context;

  ThemeService(this.context);

  get switchTheme => ThemeProvider.controllerOf(context).nextTheme();
}
