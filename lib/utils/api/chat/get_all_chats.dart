import 'package:dio/dio.dart';
import '../../../models/chat_models/chat_message.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../models/chat_models/dashboard_model.dart';

import '../api_options.dart';
import '../auth/refresh_api.dart';
import '../endpoints.dart';

class ChatGetAPIService {
  final Dio _dio = Dio();
  final storage = FlutterSecureStorage();

  Future<List<Message>> fetchChats(String otherid) async{
    await RefreshAPIService().isAccessValid();
    final uid = await storage.read(key: 'userId');
    final response = await _dio.get(
        '${Endpoints.BASE_URL}${Endpoints.message}/$uid/$otherid',
    );
    print('got it');
    print(response.data);
    if(response.statusCode == 200){
      List<dynamic> jsonData = response.data;
      return jsonData.map((data) => Message.fromJson(data)).toList();
    }
    else{
      throw Exception('Failed to load chats');
    }
  }

  Future<List<ChatDashboard>> fetchChats2() async{
    await RefreshAPIService().isAccessValid();
    final uid = await storage.read(key: 'userId');
    final response = await _dio.get(
        '${Endpoints.BASE_URL}${Endpoints.message}/$uid'
    );
    print('got it');
    print(response.data);
    if(response.statusCode == 200){
      List<dynamic> jsonData = response.data;
      return jsonData.map((data) => ChatDashboard.fromJson(data)).toList();
    }
    else{
      throw Exception('Failed to load chat2');
    }
  }

  Future<String> fetchName() async{
    await RefreshAPIService().isAccessValid();
    final uid = await storage.read(key: 'userId');
    final token = await storage.read(key: 'token');
    final response = await _dio.get(
        '${Endpoints.BASE_URL}${Endpoints.user}/e/$uid',
        options: APIOptions(token!).options
    );
    print(response.data);
    if(response.statusCode == 200){
      return response.data['name'];
    }
    else{
      throw Exception('Failed to load name');
    }
  }
}