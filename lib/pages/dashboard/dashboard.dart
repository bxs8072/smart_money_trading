import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_money_trading/apis/benzinga_api.dart';
import 'package:smart_money_trading/models/customer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_money_trading/models/ticker_notification.dart';
import 'package:smart_money_trading/pages/dashboard/trades_slider.dart';
import 'package:smart_money_trading/services/notification_service.dart';
import 'package:smart_money_trading/services/size_service.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:smart_money_trading/pages/dashboard/custom_tiles_builder/custom_tile/custom_tile.dart';
import 'package:smart_money_trading/pages/dashboard/custom_tiles_builder/custom_tiles_builder.dart';

class Dashboard extends StatefulWidget {
  final Customer customer;
  const Dashboard({Key? key, required this.customer}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
    BenzingaApi().getNews();
    return CustomScrollView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          key: widget.key,
          title: Row(
            children: [
              Text(
                "SMT",
                style: GoogleFonts.righteous(
                  fontSize: SizeService(context).height * 0.05,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: ListTile(
            leading: Text(
              "Hello, ${widget.customer.firstname}",
              style: GoogleFonts.exo2(
                fontSize: SizeService(context).height * 0.03,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Text(
              "Recent trades",
              style: GoogleFonts.exo2(
                fontSize: SizeService(context).height * 0.02,
                fontWeight: FontWeight.w300,
                // color: Colors.black38,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 1,
              horizontal: 10,
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("optionAlerts")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("optionAlerts")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<TickerNotification> list = snapshot.data!.docs
                      .map((e) => TickerNotification.fromDoc(e))
                      .toList();
                  return TradesSlider(list: list);
                }
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: CustomTilesBuilder(
              person: widget.customer,
              key: widget.key,
            ),
          ),
        ),
      ],
    );
  }
}
