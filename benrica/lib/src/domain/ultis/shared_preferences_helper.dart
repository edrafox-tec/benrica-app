import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<void> saveData<T>(String key, T data) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String dataJson = jsonEncode(data);
    await data.setString(key, dataJson);
  }

  static Future<T?> getData<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? dataJson = data.getString(key);
    if (dataJson != null) {
      Map<String, dynamic> decodedData = jsonDecode(dataJson);
      return fromJson(decodedData);
    }
    return null;
  }

  static Future<void> clearData(String key) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    await data.remove(key); // Adicionado await aqui
  }
}
