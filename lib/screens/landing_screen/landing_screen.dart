import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_money_trading/screens/authentication_screen/authentication_screen.dart';
import 'package:smart_money_trading/screens/home_landing_screen/home_landing_screen.dart';
import 'package:smart_money_trading/screens/setup_screen/setup_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  var currentIndex = 0;

  TabController get tabController => TabController(length: 3, vsync: this);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              key: widget.key,
              child: CircularProgressIndicator(
                key: widget.key,
              ),
            );
          } else {
            if (snapshot.hasData) {
              return HomeLandingScreen(key: widget.key);
            } else {
              return AuthenticationScreen(key: widget.key);
            }
          }
        });
  }
}
