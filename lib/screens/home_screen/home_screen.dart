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
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:theme_provider/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  final Customer customer;
  const HomeScreen({super.key, required this.customer});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static int currentIndex = 0;

  List<Widget> get pages => [
        Dashboard(key: widget.key, customer: widget.customer),
        NewsPage(key: widget.key, customer: widget.customer),
        AccountPage(key: widget.key, customer: widget.customer),
      ];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> createOptionAlertToken() async {
    await FirebaseFirestore.instance
        .collection("subscriptions")
        .doc(widget.customer.stripeCustomerId!)
        .get()
        .then((value) async {
      if (value.exists) {
        if (value.get("status") == "active") {
          await FirebaseMessaging.instance.getToken().then((token) async {
            await value.reference.update({"optionAlertToken": token});
            await FirebaseFirestore.instance
                .collection("customers")
                .doc(widget.customer.firebaseUid)
                .update({"optionAlertToken": token});
          });
        }
      }
    });
  }

  NotificationService notificationService = NotificationService.instance;
  @override
  void initState() {
    super.initState();
    createOptionAlertToken();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.newspaper_outlined,
                ),
                label: "News"),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_box,
              ),
              label: "Account",
            ),
          ],
          currentIndex: currentIndex,
          selectedItemColor: ThemeService(context).isDark
              ? ThemeService.light
              : ThemeService.primary,
          unselectedItemColor: ThemeService.secondary,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
