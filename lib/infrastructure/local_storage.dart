import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageKeys {
  static const String authKey = 'authorizationKey';
  static const String authentication = 'authentication';
  static const String loginProvider = 'loginPlatform';
  static const String wishlist = 'wishlist';
  static const String userDetails = 'userDetails';
  static const String currency = 'currency';
  static const String loggedUserCompany = 'loggedUserCompany';
}

class LocalStorage {
  Future<void> setDate(String key, DateTime? value) async {
    if (value != null) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(key, value.toIso8601String());
    }
  }

  Future<void> setBool(String key, bool? value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(key, value ?? false);
  }

  Future<bool> getBool(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key) ?? false;
  }

  Future<DateTime?> getDate(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? str = preferences.getString(key);
    return str != null ? DateTime.parse(str) : null;
  }

  Future<void> setString(String key, String value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  Future<void> setJson(String key, dynamic json) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String strJson = jsonEncode(json);
    preferences.setString(key, strJson);
  }

  Future<void> addToJsonArray(String key, Map<String, dynamic> element) async {
    final existingRes = await getAsJsonArray(key) ?? [];
    await setJson(key, [...existingRes, element]);
  }

  Future<void> removeFromJsonArray(
      String key, bool Function(Map<String, dynamic>) func) async {
    final existingRes = await getAsJsonArray(key) ?? [];
    await setJson(
        key, existingRes.where((element) => !func.call(element)).toList());
  }

  Future<String?> getString(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  Future<Map<String, dynamic>> getJson(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey(key)) {
      return jsonDecode(preferences.getString(key)!);
    }
    return {};
  }

  Future<List<dynamic>?> getAsJsonArray(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    var result = preferences.getString(key);
    if (result == null) return null;
    return jsonDecode(result) as List;
  }

  Future<void> remove(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(key);
  }

  Future<void> removeAll(List<String> keys) async {
    for (var element in keys) {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      preferences.remove(element);
    }
  }

  Future<void> clear() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}
