// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:http/http.dart' as http;
//
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();
//
//   late String _projectId;
//   late ServiceAccountCredentials _credentials;
//
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<void> init({
//     required String currentUserId,
//     required String serviceAccountAssetPath,
//     required GlobalKey<NavigatorState> navigatorKey,
//   }) async {
//     await Firebase.initializeApp();
//
//     final credJson = await rootBundle.loadString(serviceAccountAssetPath);
//     final Map<String, dynamic> credMap = json.decode(credJson);
//     _credentials = ServiceAccountCredentials.fromJson(credMap);
//     _projectId = credMap['project_id'];
//
//     await _updateToken(currentUserId);
//     _messaging.onTokenRefresh.listen((newToken) => _saveToken(currentUserId, newToken));
//
//     FirebaseMessaging.onMessage.listen((message) {
//       print('🔔 Foreground: ${message.notification?.title}');
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       final route = message.data['route'];
//       if (route != null) navigatorKey.currentState?.pushNamed(route);
//     });
//
//     final initialMessage = await _messaging.getInitialMessage();
//     if (initialMessage != null && initialMessage.data['route'] != null) {
//       navigatorKey.currentState?.pushNamed(initialMessage.data['route']);
//     }
//   }
//
//   Future<void> _updateToken(String userId) async {
//     final token = await _messaging.getToken();
//     if (token != null) await _saveToken(userId, token);
//   }
//
//   Future<void> _saveToken(String userId, String token) async {
//     await _firestore.collection('users').doc(userId).set({
//       'fcm_token': token,
//     }, SetOptions(merge: true));
//   }
//
//   Future<String> _getAccessToken() async {
//     final client = await clientViaServiceAccount(
//       _credentials,
//       ['https://www.googleapis.com/auth/firebase.messaging'],
//     );
//     return client.credentials.accessToken.data;
//   }
//
//   Future<void> sendNotification({
//     required String targetUserId,
//     required String title,
//     required String body,
//     String? route,
//   }) async {
//     final snap = await _firestore.collection('users').doc(targetUserId).get();
//     final targetToken = snap.data()?['fcm_token'];
//     if (targetToken == null) {
//       print('❌ لا يوجد token للمستخدم $targetUserId');
//       return;
//     }
//
//     final accessToken = await _getAccessToken();
//     final url = Uri.parse(
//       'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send',
//     );
//     final headers = {
//       HttpHeaders.contentTypeHeader: 'application/json',
//       HttpHeaders.authorizationHeader: 'Bearer $accessToken',
//     };
//     final payload = {
//       'message': {
//         'token': targetToken,
//         'notification': {'title': title, 'body': body},
//         'data': {'route': route ?? ''},
//         'android': {'notification': {'click_action': 'FLUTTER_NOTIFICATION_CLICK'}},
//         'apns': {'payload': {'aps': {'category': 'NEW_NOTIFICATION'}}},
//       }
//     };
//
//     final res = await http.post(url, headers: headers, body: jsonEncode(payload));
//     if (res.statusCode == 200) print('✅ تم الإرسال');
//     else print('❌ خطأ: ${res.body}');
//   }
// }
//
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:http/http.dart' as http;
//
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();
//
//   late String _projectId;
//   late ServiceAccountCredentials _credentials;
//
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late GlobalKey<NavigatorState> _navigatorKey;
//
//   Future<void> init({
//     required String currentUserId,
//     required String serviceAccountAssetPath,
//     required GlobalKey<NavigatorState> navigatorKey,
//   }) async {
//     await Firebase.initializeApp();
//     _navigatorKey = navigatorKey;
//
//     final credJson = await rootBundle.loadString(serviceAccountAssetPath);
//     final credMap = json.decode(credJson);
//     _credentials = ServiceAccountCredentials.fromJson(credMap);
//     _projectId = credMap['project_id'];
//
//     await _saveFcmToken(currentUserId);
//     _messaging.onTokenRefresh.listen((token) => _saveFcmToken(currentUserId));
//
//     // Foreground
//     FirebaseMessaging.onMessage.listen((message) {
//       print('📥 إشعار وارد أثناء تشغيل التطبيق');
//       print('Title: ${message.notification?.title}');
//       print('Body: ${message.notification?.body}');
//     });
//
//     // Background
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       _handleMessageNavigation(message);
//     });
//
//     // Terminated
//     final initialMessage = await _messaging.getInitialMessage();
//     if (initialMessage != null) {
//       _handleMessageNavigation(initialMessage);
//     }
//   }
//
//   Future<void> _saveFcmToken(String userId) async {
//     final token = await _messaging.getToken();
//     if (token != null) {
//       await _firestore.collection('users').doc(userId).set({
//         'fcm_token': token,
//       }, SetOptions(merge: true));
//       print('✅ تم حفظ FCM Token للمستخدم $userId');
//     }
//   }
//
//   // void _handleMessageNavigation(RemoteMessage message) {
//   //   final route = message.data['route'];
//   //   if (route != null && route.isNotEmpty) {
//   //     _navigatorKey.currentState?.pushNamed(route);
//   //   }
//   // }
//   void _handleMessageNavigation(RemoteMessage message) {
//     print('🧭 محاولة تنقل بناءً على الإشعار');
//     print('📦 Payload: ${message.data}');
//     final route = message.data['route'];
//     if (route != null && route.isNotEmpty) {
//       print('🔁 الانتقال إلى: $route');
//       _navigatorKey.currentState?.pushNamed(route);
//     } else {
//       print('⚠️ لا يوجد route في البيانات');
//     }
//   }
//
//
//   Future<String> _getAccessToken() async {
//     final client = await clientViaServiceAccount(
//       _credentials,
//       ['https://www.googleapis.com/auth/firebase.messaging'],
//     );
//     return client.credentials.accessToken.data;
//   }
//
//   Future<void> sendNotification({
//     required String targetUserId,
//     required String title,
//     required String body,
//     String? route,
//   }) async {
//     final snap = await _firestore.collection('users').doc(targetUserId).get();
//     final targetToken = snap.data()?['fcm_token'];
//     if (targetToken == null) {
//       print('❌ لا يوجد token للمستخدم $targetUserId');
//       return;
//     }
//
//     final accessToken = await _getAccessToken();
//     final url = Uri.parse(
//       'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send',
//     );
//     final headers = {
//       HttpHeaders.contentTypeHeader: 'application/json',
//       HttpHeaders.authorizationHeader: 'Bearer $accessToken',
//     };
//     final payload = {
//       'message': {
//         'token': targetToken,
//         'notification': {'title': title, 'body': body},
//         'data': {'route': route ?? ''},
//         'android': {
//           'notification': {'click_action': 'FLUTTER_NOTIFICATION_CLICK'}
//         },
//         'apns': {
//           'payload': {'aps': {'category': 'NEW_NOTIFICATION'}}
//         },
//       }
//     };
//
//     final res = await http.post(url, headers: headers, body: jsonEncode(payload));
//     if (res.statusCode == 200) {
//       print('✅ تم إرسال الإشعار');
//     } else {
//       print('❌ فشل الإرسال: ${res.body}');
//     }
//   }
// }
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:http/http.dart' as http;
//
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();
//
//   late String _projectId;
//   late ServiceAccountCredentials _credentials;
//
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late GlobalKey<NavigatorState> _navigatorKey;
//
//   Future<void> init({
//     required String currentUserId,
//     required String serviceAccountAssetPath,
//     required GlobalKey<NavigatorState> navigatorKey,
//   }) async {
//     await Firebase.initializeApp();
//     _navigatorKey = navigatorKey;
//
//     final credJson = await rootBundle.loadString(serviceAccountAssetPath);
//     final credMap = json.decode(credJson);
//     _credentials = ServiceAccountCredentials.fromJson(credMap);
//     _projectId = credMap['project_id'];
//
//     await _saveFcmToken(currentUserId);
//     _messaging.onTokenRefresh.listen((token) => _saveFcmToken(currentUserId));
//
//     // Foreground
//     FirebaseMessaging.onMessage.listen((message) {
//       print('📥 إشعار وارد أثناء تشغيل التطبيق');
//       print('Title: ${message.notification?.title}');
//       print('Body: ${message.notification?.body}');
//     });
//
//     // Background
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       _handleMessageNavigation(message);
//     });
//   }
//
//   Future<void> _saveFcmToken(String userId) async {
//     final token = await _messaging.getToken();
//     if (token != null) {
//       await _firestore.collection('users').doc(userId).set({
//         'fcm_token': token,
//       }, SetOptions(merge: true));
//       print('✅ تم حفظ FCM Token للمستخدم $userId');
//     }
//   }
//
//   void _handleMessageNavigation(RemoteMessage message) {
//     final route = message.data['route'];
//     if (route != null && route.isNotEmpty) {
//       print('🔁 الانتقال إلى: $route');
//       _navigatorKey.currentState?.pushNamed(route);
//     }
//   }
//
//   Future<String> _getAccessToken() async {
//     final client = await clientViaServiceAccount(
//       _credentials,
//       ['https://www.googleapis.com/auth/firebase.messaging'],
//     );
//     return client.credentials.accessToken.data;
//   }
//
//   Future<void> sendNotification({
//     required String targetUserId,
//     required String title,
//     required String body,
//     String? route,
//   }) async {
//     final snap = await _firestore.collection('users').doc(targetUserId).get();
//     final targetToken = snap.data()?['fcm_token'];
//     if (targetToken == null) {
//       print('❌ لا يوجد token للمستخدم $targetUserId');
//       return;
//     }
//
//     final accessToken = await _getAccessToken();
//     final url = Uri.parse(
//       'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send',
//     );
//     final headers = {
//       HttpHeaders.contentTypeHeader: 'application/json',
//       HttpHeaders.authorizationHeader: 'Bearer $accessToken',
//     };
//     final payload = {
//       'message': {
//         'token': targetToken,
//         'notification': {'title': title, 'body': body},
//         'data': {'route': route ?? ''},
//         'android': {
//           'notification': {'click_action': 'FLUTTER_NOTIFICATION_CLICK'}
//         },
//         'apns': {
//           'payload': {'aps': {'category': 'NEW_NOTIFICATION'}}
//         },
//       }
//     };
//
//     final res = await http.post(url, headers: headers, body: jsonEncode(payload));
//     if (res.statusCode == 200) {
//       print('✅ تم إرسال الإشعار');
//     } else {
//       print('❌ فشل الإرسال: ${res.body}');
//     }
//   }
// }
//

import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  late String _projectId;
  late ServiceAccountCredentials _credentials;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late GlobalKey<NavigatorState> _navigatorKey;

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> init({
    required String currentUserId,
    required String serviceAccountAssetPath,
    required GlobalKey<NavigatorState> navigatorKey,
  }) async {
    await Firebase.initializeApp();
    _navigatorKey = navigatorKey;

    final credJson = await rootBundle.loadString(serviceAccountAssetPath);
    final credMap = json.decode(credJson);
    _credentials = ServiceAccountCredentials.fromJson(credMap);
    _projectId = credMap['project_id'];

    await _saveFcmToken(currentUserId);
    _messaging.onTokenRefresh.listen((token) => _saveFcmToken(currentUserId));

    await _initializeLocalNotifications();

    // Foreground
    // FirebaseMessaging.onMessage.listen((message) {
    //   _showLocalNotification(message);
    // });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📥 إشعار داخل التطبيق (foreground)');
      print('🔔 Title: ${message.notification?.title}');
      print('📄 Body: ${message.notification?.body}');
      print('📦 Payload: ${message.data}');
      _showLocalNotification(message);
    });


    // Background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessageNavigation(message);
    });
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        final route = response.payload;
        if (route != null && route.isNotEmpty) {
          _navigatorKey.currentState?.pushNamed(route);
        }
      },
    );
  }

  // Future<void> _showLocalNotification(RemoteMessage message) async {
  //   const androidDetails = AndroidNotificationDetails(
  //     'default_channel',
  //     'Default Notifications',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //
  //   const iosDetails = DarwinNotificationDetails();
  //   const notificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);
  //
  //   await _localNotifications.show(
  //     0,
  //     message.notification?.title ?? 'تنبيه',
  //     message.notification?.body ?? '',
  //     notificationDetails,
  //     payload: message.data['route'],
  //   );
  // }
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel', // يجب أن يكون ثابت ومعروف
      'Default Notifications',
      channelDescription: 'Channel for basic notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique id لكل إشعار
      message.notification?.title ?? 'تنبيه',
      message.notification?.body ?? '',
      notificationDetails,
      payload: message.data['route'],
    );
  }

  Future<void> _saveFcmToken(String userId) async {
    final token = await _messaging.getToken();
    if (token != null) {
      await _firestore.collection('users').doc(userId).set({
        'fcm_token': token,
      }, SetOptions(merge: true));
      print('✅ تم حفظ FCM Token للمستخدم $userId');
    }
  }

  void _handleMessageNavigation(RemoteMessage message) {
    final route = message.data['route'];
    if (route != null && route.isNotEmpty) {
      print('🔁 الانتقال إلى: $route');
      _navigatorKey.currentState?.pushNamed(route);
    }
  }

  Future<String> _getAccessToken() async {
    final client = await clientViaServiceAccount(
      _credentials,
      ['https://www.googleapis.com/auth/firebase.messaging'],
    );
    return client.credentials.accessToken.data;
  }

  Future<void> sendNotification({
    required String targetUserId,
    required String title,
    required String body,
    String? route,
  }) async {
    final snap = await _firestore.collection('users').doc(targetUserId).get();
    final targetToken = snap.data()?['fcm_token'];
    if (targetToken == null) {
      print('❌ لا يوجد token للمستخدم $targetUserId');
      return;
    }

    final accessToken = await _getAccessToken();
    final url = Uri.parse(
      'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send',
    );
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
    };
    final payload = {
      'message': {
        'token': targetToken,
        'notification': {'title': title, 'body': body},
        'data': {
          'route': route ?? '',
          'click_action': 'FLUTTER_NOTIFICATION_CLICK' // داخل data (وليس android.notification)
        },
        // 'android': {
        //   'notification': {'click_action': 'FLUTTER_NOTIFICATION_CLICK'}
        // },
        'apns': {
          'payload': {'aps': {'category': 'NEW_NOTIFICATION'}}
        },
      }
    };

    final res = await http.post(url, headers: headers, body: jsonEncode(payload));
    if (res.statusCode == 200) {
      print('✅ تم إرسال الإشعار');
      print('📤 Sending notification to token: $targetToken');
      print('📦 Payload: ${jsonEncode(payload)}');
      print('📬 Response code: ${res.statusCode}');
      print('📬 Response body: ${res.body}');

    } else {
      print('❌ فشل الإرسال: ${res.body}');
    }
  }
}

