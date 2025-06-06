import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../endpoints.dart';

class RefreshAPIService {
  final Dio _dio = Dio();
  final storage = FlutterSecureStorage();
  Completer<String>? _refreshCompleter;

  Future<void> isAccessValid() async {
    final token = await storage.read(key: 'token');

    if (token == null) {
      throw Exception('No access token found. User must log in again.');
    }

    DateTime expirationDate = JwtDecoder.getExpirationDate(token);
    print("Expiration Access : $expirationDate");
    bool isExpired = expirationDate.isBefore(DateTime.now());

    if (isExpired) {
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
      final uid = await storage.read(key: 'userId');
      final rtoken = await storage.read(key: 'rtoken');

      if (rtoken == null) {
        throw Exception('Refresh token missing. Please log in again.');
      }

      final response = await _dio.post(
        '${Endpoints.BASE_URL}${Endpoints.refresh_token}/$uid',
        data: {"refreshToken": rtoken},
      );

      if (response.statusCode == 201) {
        final newToken = response.data['token'];
        await storage.write(key: 'token', value: newToken);
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
