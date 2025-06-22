import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Call this method in main()
  static Future<void> initialize() async {
    await Firebase.initializeApp();
    await _requestPermission();
    await _initializeLocalNotifications();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  static final Dio _dio = Dio();

  static Future<void> sendPushMessage({
    required String targetToken,
    required String title,
    required String body,
  }) async {
    const String serverKey = 'YOUR_SERVER_KEY'; // 🔥 حط مفتاح الـ Server Key بتاعك هنا

    try {
      final response = await _dio.post(
        'https://fcm.googleapis.com/fcm/send',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey',
          },
        ),
        data: {
          'to': targetToken,
          'notification': {
            'title': title,
            'body': body,
          },
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
          },
        },
      );

      if (response.statusCode == 200) {
        print('✅ Notification Sent Successfully');
      } else {
        print('❌ Failed to send notification: ${response.statusMessage}');
      }
    } catch (e) {
      print('❗ Error sending notification: $e');
    }
  }
  // static Future<void> sendPushMessage(
  //     String token, String title, String body) async {
  //   final serverKey = 'YOUR_SERVER_KEY'; // استبدل بمفتاح الخادم الخاص بك
  //
  //   // final response = await http.post(
  //   //   Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //   //   headers: <String, String>{
  //   //     'Content-Type': 'application/json',
  //   //     'Authorization': 'key=$serverKey',
  //   //   },
  //   //     final response = await dio.post(
  //   //
  //   // 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
  //   //     data: jsonEncode(message),
  //   // );
  //     body: jsonEncode(
  //       <String, dynamic>{
  //         'notification': <String, dynamic>{
  //           'title': title,
  //           'body': body,
  //         },
  //         'priority': 'high',
  //         'to': token,
  //       },
  //     ),
  //   );
  //
  //   if (response.statusCode != 200) {
  //     print('فشل في إرسال الإشعار: ${response.body}');
  //   }
  // }
  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _localNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    _showNotification(message);
  }

  void setupOnMessageListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // تعامل مع فتح التطبيق من الإشعار
    });
  }

  Future<String?> getDeviceToken() async {
    return await _fcm.getToken();
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'default_channel',
      'Default',
      channelDescription: 'Default notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotificationsPlugin.show(
      0,
      message.notification?.title ?? 'إشعار جديد',
      message.notification?.body ?? '',
      platformChannelSpecifics,
    );
  }
}
