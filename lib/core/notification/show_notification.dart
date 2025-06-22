import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // تهيئة الإشعارات المحلية
  Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // إرسال إشعار محلي
  Future<void> showNotification(String title, String message) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'workshop_channel',
      'Workshop Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      notificationDetails,
    );
  }
}
