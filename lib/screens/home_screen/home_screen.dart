import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:smart_money_trading/pages/account-page/account_page.dart';
import 'package:smart_money_trading/pages/dashboard/dashboard.dart';
import 'package:smart_money_trading/pages/news-page/news_page.dart';
import 'package:smart_money_trading/services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  final Customer customer;
  const HomeScreen({super.key, required this.customer});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  List<Widget> get pages => [
        Dashboard(key: widget.key, customer: widget.customer),
        NewsPage(key: widget.key, customer: widget.customer),
        AccountPage(key: widget.key, customer: widget.customer),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: "News"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box), label: "Account"),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
