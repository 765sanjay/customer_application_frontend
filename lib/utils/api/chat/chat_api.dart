import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api_options.dart';
import '../endpoints.dart';

import '../auth/refresh_api.dart';

class ChatAPIService{
  final Dio _dio = Dio();
  final storage = FlutterSecureStorage();

  Future<void> saveAndSendToken(String userId) async {
    await RefreshAPIService().isAccessValid();
    final messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    final token = await messaging.getToken();
    updateTokenOnServer(token!, userId);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
    print("fcm ${token}");
    // await sendMessage(token);
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      updateTokenOnServer(newToken, userId);
    });
  }

  Future<void> sendMessage(String token) async {
    await RefreshAPIService().isAccessValid();
    final token = await storage.read(key: 'token');
    final response = await _dio.post(
        '${Endpoints.BASE_URL}${Endpoints.notification}${Endpoints.notification_send}',
        data: {
          'title': "Bob",
          "body": "HI"
        },
        options: Options(
            headers: {
              'fcm': token,
            },

        )
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Token successfully sent to the server');
    } else {
      print('Failed to send token to the server');
    }
  }
  Future<void> updateTokenOnServer(String token, String userId) async {
    final jwttoken = await storage.read(key: 'token');
    final response = await _dio.put(
      '${Endpoints.BASE_URL}${Endpoints.user}${Endpoints.notification_update}/$userId',
      data: {
        'fcmToken': token,
      },
      options: APIOptions(jwttoken!).options
    );
    if(response.statusCode == 200 || response.statusCode == 201){
      print('Token Successfully sent to server');
    }
    else{
      print('Failed to sent fcm token');
    }
  }
}