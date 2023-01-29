import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_money_trading/screens/authentication_screen/authentication_screen.dart';
import 'package:smart_money_trading/screens/home_landing_screen/home_landing_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              key: key,
              child: CircularProgressIndicator(
                key: key,
              ),
            );
          } else {
            if (snapshot.hasData) {
              return HomeLandingScreen(key: key);
            } else {
              return AuthenticationScreen(key: key);
            }
          }
        });
  }
}
