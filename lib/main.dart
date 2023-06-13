import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_money_trading/firebase_options.dart';
import 'package:smart_money_trading/screens/landing_screen/landing_screen.dart';
import 'package:smart_money_trading/services/notification_service.dart';
import 'package:smart_money_trading/services/theme_services/dark_theme.dart';
import 'package:smart_money_trading/services/theme_services/light_theme.dart';
import 'package:smart_money_trading/services/theme_services/theme_service.dart';
import 'package:theme_provider/theme_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest_all.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  print("Handled Notification");
}

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

Future<void> handleAndroidNotification() async {
  await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestPermission();
}

Future<void> handleIosNotification() async {
  await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()!
      .requestPermissions(alert: true, sound: true, badge: true);
}

Future<void> configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

void handleNotifications() {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    Map<String, dynamic> data = json.decode(message.data["data"]);
    NotificationService.instance.showNotification(
      notification: MyNotification(
        id: 0,
        title: message.notification!.title!,
        body: message.notification!.body!,
        data: data,
      ),
    );
  });

  FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
    Map<String, dynamic> data = json.decode(message.data["data"]);
    NotificationService.instance.showNotification(
      notification: MyNotification(
        id: 3,
        title: message.notification!.title!,
        body: message.notification!.body!,
        data: data,
      ),
    );
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    Map<String, dynamic> data = json.decode(message.data["data"]);
    NotificationService.instance.showNotification(
      notification: MyNotification(
        id: 1,
        title: message.notification!.title!,
        body: message.notification!.body!,
        data: data,
      ),
    );
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await requestPermission();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  if (Platform.isAndroid) {
    await handleAndroidNotification();
  }
  if (Platform.isIOS) {
    await handleIosNotification();
  }
  await configureLocalTimeZone();
  await FirebaseMessaging.instance.getInitialMessage();
  await NotificationService.instance.initialize();
  handleNotifications();
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
