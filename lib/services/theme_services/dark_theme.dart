import 'package:flutter/material.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:theme_provider/theme_provider.dart';

class DarkTheme {
  static const secondaryColor = Color(0xFFC1C1C1);

  static AppTheme appTheme = AppTheme(
    id: ThemeService.darkId,
    data: ThemeData.dark(useMaterial3: true).copyWith(
      useMaterial3: true,
      primaryColor: ThemeService.primary,
      errorColor: ThemeService.error,
      indicatorColor: ThemeService.primary,
      focusColor: ThemeService.primary,
      dividerColor: ThemeService.light,
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(
          color: secondaryColor,
        ),
        actionsIconTheme: IconThemeData(
          color: secondaryColor,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: ThemeService.primary,
      ),
      tabBarTheme: const TabBarTheme(
        unselectedLabelColor: secondaryColor,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        labelColor: ThemeService.primary,
      ),
      iconTheme: const IconThemeData(
        color: secondaryColor,
      ),
      primaryIconTheme: const IconThemeData(
        color: secondaryColor,
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          foregroundColor: ThemeService.primary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: ThemeService.primary,
          foregroundColor: ThemeService.light,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            foregroundColor: ThemeService.primary,
            side: const BorderSide(
              color: ThemeService.secondary,
            )),
      ),
    ),
    description: "Dark Theme",
  );
}
