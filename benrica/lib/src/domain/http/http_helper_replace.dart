// ignore_for_file: non_constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class HelperHttp {
  Future<Map<String, dynamic>> processUrl(String url, [int? idSpecific]) async {
    final token = await _getToken();
    final id_business = await _getIdBusinesses();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    if (id_business != null && idSpecific == null) {
      url = url.replaceAll(':id', id_business);
    } else if (idSpecific != null) {
      url = url.replaceAll(':id', idSpecific.toString());
    } else {
      throw ArgumentError(
          'idSpecific must be provided if id_business is not available.');
    }

    return {'url': url, 'headers': headers};
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') == null) {
      return '';
    } else {
      String cleanedToken = prefs.getString('token')!.replaceAllMapped(
            RegExp(r'^"(.*)"$'),
            (match) => match.group(1) ?? '',
          );
      return cleanedToken;
    }
  }

  Future<String?> _getIdBusinesses() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('id_business') == null) {
      return '';
    } else {
      return prefs.getString('id_business');
    }
  }
}
