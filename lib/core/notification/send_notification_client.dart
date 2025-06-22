import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class FCMService {

  final String _projectId = 'wallpaper-6f9a7'; // استبدل بمعرف مشروعك
  final String _serviceAccountPath = 'assets/wallpaper-6f9a7-firebase-adminsdk-mq134-52965a2f57.json'; // استبدل بمسار ملف الخدمة

  Future<String> _getAccessToken() async {
    final serviceAccount = ServiceAccountCredentials.fromJson(
      json.decode(await File(_serviceAccountPath).readAsString()),
    );

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final client = await clientViaServiceAccount(serviceAccount, scopes);
    return client.credentials.accessToken.data;
  }

  Future<void> sendNotification({
    required String targetToken,
    required String title,
    required String body,
  }) async {
    final accessToken = await _getAccessToken();
    final url = 'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send';

    final message = {
      'message': {
        'token': targetToken,
        'notification': {
          'title': title,
          'body': body,
        },
      },
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(message),
    );

    if (response.statusCode != 200) {
      print('Failed to send notification: ${response.body}');
    }
  }
}
