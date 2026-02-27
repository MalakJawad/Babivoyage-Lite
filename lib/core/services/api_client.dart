import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient(this.baseUrl);

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');

    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...?headers,
      },
      body: jsonEncode(body ?? {}),
    );

    Map<String, dynamic> data = {};
    try {
      data = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {}

    if (res.statusCode >= 400) {
     
      if (data['errors'] is Map) {
        final errors = data['errors'] as Map;
        final firstKey = errors.keys.first;
        final firstMsg = (errors[firstKey] as List).first.toString();
        throw Exception(firstMsg);
      }
      throw Exception(data['message']?.toString() ?? 'Request failed');
    }

    return data;
  }
}