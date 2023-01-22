import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_money_trading/firebase_options.dart';
import 'package:smart_money_trading/screens/landing_screen/landing_screen.dart';
import 'package:smart_money_trading/services/theme_services/dark_theme.dart';
import 'package:smart_money_trading/services/theme_services/light_theme.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:theme_provider/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themes: [
        LightTheme.appTheme,
        DarkTheme.appTheme,
      ],
      defaultThemeId: ThemeService.lightId,
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      child: Builder(builder: (themeContext) {
        return ThemeConsumer(
          key: key,
          child: MaterialApp(
            theme: ThemeProvider.themeOf(themeContext).data,
            key: key,
            debugShowCheckedModeBanner: false,
            home: LandingScreen(key: key),
          ),
        );
      }),
    );
  }
}