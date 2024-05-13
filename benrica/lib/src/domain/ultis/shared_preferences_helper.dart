import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<void> saveData<T>(String key, T data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dataJson = jsonEncode(data);
    await prefs.setString(key, dataJson); // Adicionado await aqui
  }

  static Future<T?> getData<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dataJson = prefs.getString(key);
    if (dataJson != null) {
      Map<String, dynamic> decodedData = jsonDecode(dataJson);
      return fromJson(decodedData);
    }
    return null;
  }

  static Future<void> clearData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key); // Adicionado await aqui
  }
}
