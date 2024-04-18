import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class IHttpClient {
  Future get({required String url, required Map<String, String> headers});
  Future post(
      {required String url,
      required Map<String, String> headers,
      required dynamic body});
}

class HttpClientAdapter implements IHttpClient {
  final http.Client client = http.Client();

  @override
  Future get(
      {required String url, required Map<String, String> headers}) async {
    return await client.get(Uri.parse(url), headers: headers);
  }

  @override
  Future post(
      {required String url,
      required Map<String, String> headers,
      required dynamic body}) async {
    return await client.post(Uri.parse(url),
        headers: headers, body: jsonEncode(body));
  }
}
