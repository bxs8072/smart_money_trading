import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get notificationPlugin =>
      _flutterLocalNotificationsPlugin;

  Future<void> initialize() async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    notificationPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      print("NotificationResponse: ${response.payload}");
      if (response.payload != null) {
        Map<String, dynamic> data = json.decode(response.payload!);
        print("Data: $data");
      }
    });
  }

  Future<void> showNotification({required MyNotification notification}) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      notification.body.toString(),
      htmlFormatBigText: true,
      contentTitle: notification.title.toString(),
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "smt",
      "smt",
      importance: Importance.max,
      styleInformation: bigTextStyleInformation,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentSound: true,
      presentAlert: true,
      presentBadge: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      notificationDetails,
      payload: json.encode(notification.data),
    );
  }
}

class MyNotification {
  final int id;
  final String title;
  final String body;
  final Map<String, dynamic> data;

  MyNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.data,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "data": data,
      };

  factory MyNotification.fromJson(dynamic jsonData) {
    return MyNotification(
      id: jsonData["id"],
      title: jsonData["title"],
      body: jsonData["body"],
      data: jsonData["data"],
    );
  }
}
