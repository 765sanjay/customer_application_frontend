import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../chat/chat_api.dart';

import '../../socket/socket_service.dart';
import '../api_options.dart';
import '../endpoints.dart';

class LoginAPIService {
  final Dio dio = Dio();
  final storage = FlutterSecureStorage();

  Future<String> login(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final response = await dio.post(
          '${Endpoints.BASE_URL}${Endpoints.login}',
          data: {'username': email, 'password': password},
      );
      if (response.statusCode == 200) {
        prefs.setBool("is_logged", true);
        await storage.write(key: 'token', value: response.data['token']);
        await storage.write(key: 'rtoken', value: response.data['rtoken']);
        await storage.write(key: 'userId', value: response.data['userId']);
        await ChatAPIService().saveAndSendToken(response.data['userId']);
        SocketService().initialize(response.data['userId']);
        print("socket service initialized for ${response.data['userId']}");
      }
      return response.data['message'];

    } on DioException catch (error) {
      if (error.response != null) {
        return error.response!.data['message'] ??
            'An error occurred';
      } else {
        print('Error without response: ${error.message}');
        return 'Failed to connect to the server';
      }
    }
    catch (error) {
      throw Exception('Failed to login: $error');
    }
  }
}