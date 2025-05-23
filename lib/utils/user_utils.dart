// lib/user_utils.dart

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sklyit/utils/refresh.dart';
import '../api/user-data.dart';

class UserUtils {
  static const _keyIsLoggedIn = 'isLoggedIn';
  static const keyJwt = 'jwt-access-token';
  static const keyJwtRefresh = 'jwt-refresh-token';

  static String? avatarPath;

  static const baseUrl = 'http://192.168.154.119:3000';
  static String? jwt;
  static String? jwtRefresh;

  static Map<String, dynamic>? preferences;
  static Map<String, dynamic>? user;

  static Timer? _refreshTimer;

  static FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Save login status
  static Future<void> saveLoginStatus(
      bool isLoggedIn, String? jwtAccessToken, String? jwtRefreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_keyIsLoggedIn, isLoggedIn);
    await _storage.write(key: keyJwt, value: jwtAccessToken);
    await _storage.write(key: keyJwtRefresh, value: jwtRefreshToken);
    jwt = jwtAccessToken;
    jwtRefresh = jwtRefreshToken;
  }

  static Future<void> fetchUser() async {
    var up = (await getUserPreferences());
    preferences = jsonDecode(up.body);
    var ud = (await getUserDetails());

    user = jsonDecode(ud.body);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn =
        prefs.getBool(_keyIsLoggedIn) ?? false; // Default is false if no value
    if (isLoggedIn) {
      _refreshTimer =
          Timer.periodic(Duration(seconds: 14 * 60 + 45), (timer) async {
        await RefreshAPIService().isAccessValid();
      });
      jwt = await getJwt();
      await fetchUser();
      print('User: $user');
      print('Preferences: $preferences');
      print('JWT: $jwt');
      return true;
    } else {
      return false;
    }
  }

  // Get jwt
  static Future<String?> getJwt() async {
    return await _storage.read(key: keyJwt);
  }

  // Clear login status (log out)
  static Future<void> clearLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyIsLoggedIn);
    await _storage.delete(key: keyJwt);
    await _storage.delete(key: keyJwtRefresh);
  }
}
