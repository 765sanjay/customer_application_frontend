import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sklyit/utils/user_utils.dart';
import 'dart:async';
import 'package:dio/dio.dart';

class RefreshAPIService {
  final Dio _dio = Dio();
  final storage = FlutterSecureStorage();
  Completer<String>? _refreshCompleter;

  Future<void> isAccessValid() async {
    final token = await storage.read(key: UserUtils.keyJwt);

    if (token == null) {
      throw Exception('No access token found. User must log in again.');
    }

    DateTime expirationDate = JwtDecoder.getExpirationDate(token);
    print("Expiration Access : $expirationDate");
    bool isExpired = expirationDate.isBefore(DateTime.now().subtract(Duration(seconds: 30)));

    if (isExpired) {
      print('Token expired. Refreshing token...');
      await _refreshAccessToken();
    }
  }

  Future<void> _refreshAccessToken() async {
    if (_refreshCompleter != null) {
      await _refreshCompleter!.future;
      return;
    }

    _refreshCompleter = Completer();

    try {
      final uid = UserUtils.user!['userId'];
      final rtoken = await storage.read(key: UserUtils.keyJwtRefresh);

      if (rtoken == null) {
        throw Exception('Refresh token missing. Please log in again.');
      }

      final response = await _dio.post(
        '${UserUtils.baseUrl}/auth_customer/refresh/$uid',
        data: {"refreshToken": rtoken},
      );

      if (response.statusCode == 201) {
        final newToken = response.data['token'];
        await storage.write(key: UserUtils.keyJwt, value: newToken);
        _refreshCompleter!.complete(newToken);
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (error) {
      _refreshCompleter!.completeError(error);
      throw Exception('Failed to refresh token: $error');
    } finally {
      _refreshCompleter = null;
    }
  }
}

class CheckRefreshValid{
  final storage = FlutterSecureStorage();

  Future<bool> isRefreshValid() async {
    final rtoken = await storage.read(key: UserUtils.keyJwtRefresh);
    DateTime expirationDate = JwtDecoder.getExpirationDate(rtoken!);

    DateTime now = DateTime.now();
    print("Expiration (Refresh) : $expirationDate");

    bool isToday = now.year >= expirationDate.year &&
        now.month >= expirationDate.month &&
        now.day >= expirationDate.day;
    if(isToday){
      return false;
    }
    return true;
  }
}