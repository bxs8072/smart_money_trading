import 'package:flutter/material.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:theme_provider/theme_provider.dart';

class LightTheme {
  static AppTheme appTheme = AppTheme(
    id: ThemeService.lightId,
    data: ThemeData.light(useMaterial3: false).copyWith(
      primaryColor: ThemeService.primary,
      errorColor: ThemeService.error,
      indicatorColor: ThemeService.primary,
      focusColor: ThemeService.primary,
      dividerColor: ThemeService.light,
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeService.primary,
        iconTheme: IconThemeData(
          color: ThemeService.secondary,
        ),
        actionsIconTheme: IconThemeData(
          color: ThemeService.secondary,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: ThemeService.primary,
      ),
      tabBarTheme: const TabBarTheme(
        unselectedLabelColor: ThemeService.secondary,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        labelColor: ThemeService.primary,
      ),
      iconTheme: const IconThemeData(
        color: ThemeService.secondary,
      ),
      primaryIconTheme: const IconThemeData(
        color: ThemeService.secondary,
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
    description: "Light Mode Theme",
  );
}

/*
ThemeData(
      useMaterial3: true,
      primaryColor: ThemeService.primary,
      errorColor: ThemeService.error,
      primaryColorLight: ThemeService.primary,
      indicatorColor: ThemeService.primary,
      backgroundColor: Colors.white,
      dialogBackgroundColor: ThemeService.light,
      fontFamily: GoogleFonts.openSans().fontFamily,
      secondaryHeaderColor: ThemeService.secondary,
      focusColor: ThemeService.primary,
      hintColor: ThemeService.secondary,
      dividerColor: ThemeService.secondary,
      primaryColorDark: ThemeService.dark,
      scaffoldBackgroundColor: Colors.white,
      hoverColor: ThemeService.primary,
      disabledColor: ThemeService.secondary,
      appBarTheme: const AppBarTheme(
        actionsIconTheme: IconThemeData(
          color: ThemeService.secondary,
        ),
        iconTheme: IconThemeData(
          color: ThemeService.secondary,
        ),
        titleSpacing: 2.0,
      ),
      tabBarTheme: const TabBarTheme(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: ThemeService.primary,
          ),
        ),
        labelColor: ThemeService.primary,
        unselectedLabelColor: ThemeService.dark,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: ThemeService.secondary,
      ),
      iconTheme: const IconThemeData(
        color: ThemeService.secondary,
      ),
      primaryIconTheme: const IconThemeData(
        color: ThemeService.secondary,
      ),
      primaryTextTheme: const TextTheme(
        bodyText1: TextStyle(
          // Tab Bar Text
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: const TextTheme(
        bodyText1: TextStyle(
          fontWeight: FontWeight.w600,
        ), // Tabbar text
        bodyText2: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        subtitle1: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        button: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        headline6: TextStyle(
          // Appbar Title Text
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
        subtitle2: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0.00,
          backgroundColor: ThemeService.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: ThemeService.secondary,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          elevation: 0.00,
          foregroundColor: ThemeService.primary,
          disabledBackgroundColor: ThemeService.secondary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0.00,
          foregroundColor: ThemeService.primary,
          side: const BorderSide(
            color: ThemeService.primary,
          ),
          disabledBackgroundColor: ThemeService.secondary,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0.00,
        selectedItemColor: ThemeService.primary,
        unselectedItemColor: ThemeService.secondary,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        prefixIconColor: ThemeService.primary,
        suffixIconColor: ThemeService.primary,
      ),
    ),
   
 */
