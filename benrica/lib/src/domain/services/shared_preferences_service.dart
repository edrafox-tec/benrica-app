import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<bool> saveSharedData(String key, String value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getSharedData(String key) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      return null;
    }
  }

  Future<bool> removeSharedData(
    String key,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      return true;
    } catch (e) {
      return false;
    }
  }
}
