import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:smart_money_trading/pages/account-page/account_page.dart';
import 'package:smart_money_trading/pages/dashboard/dashboard.dart';
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
        Dashboard(key: widget.key, person: widget.customer),
        AccountPage(key: widget.key, customer: widget.customer),
        AccountPage(key: widget.key, customer: widget.customer),
      ];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> requestPermission() async {
    NotificationSettings notificationSettings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    switch (notificationSettings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        print("User Granted Permission");
        break;
      case AuthorizationStatus.provisional:
        print("User Granted Provisional Permission");
        break;
      case AuthorizationStatus.notDetermined:
        print("Not Determined Permission");
        break;
      default:
        print("User Declined Permission");
        break;
    }
  }

  Future<void> createOptionAlertToken() async {
    await FirebaseFirestore.instance
        .collection("subscriptions")
        .doc(widget.customer.stripeCustomerId!)
        .get()
        .then((value) async {
      if (value.exists) {
        if (value.get("status") == "active") {
          await FirebaseMessaging.instance.getToken().then((token) async {
            value.reference.update({"optionAlertToken": "token"});
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
    requestPermission();

    notificationService.initialize(context);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Map<String, dynamic> data = json.decode(message.data["data"]);
      notificationService.showNotification(
        notification: MyNotification(
          id: 0,
          title: message.notification!.title!,
          body: message.notification!.body!,
          data: data,
        ),
      );
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Map<String, dynamic> data = json.decode(message.data["data"]);
      notificationService.showNotification(
        notification: MyNotification(
          id: 1,
          title: message.notification!.title!,
          body: message.notification!.body!,
          data: data,
        ),
      );
    });
  }

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
