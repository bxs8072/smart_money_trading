import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_money_trading/screens/home_screen/home_screen.dart';
import 'package:smart_money_trading/screens/setup_screen/setup_screen.dart';

class HomeLandingScreen extends StatelessWidget {
  const HomeLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("customers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.data!["setup"]) {
            return HomeScreen(key: key);
          } else {
            return SetupScreen(key: key);
          }
        }
      },
    );
  }
}
