import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveString(
    String key,
    String value,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> loadString(
    String key,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> saveJson(
    String key,
    dynamic data,
  ) async {
    await saveString(key, jsonEncode(data));
  }

  static Future<dynamic> loadJson(
    String key,
  ) async {
    final json = await loadString(key);

    if (json == null) return null;

    return jsonDecode(json);
  }

  static Future<void> delete(
    String key,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}