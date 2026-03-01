import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  ApiClient(this.baseUrl);

  Uri _u(String path, [Map<String, String>? q]) =>
      Uri.parse('$baseUrl$path').replace(queryParameters: q);

  Map<String, String> _mergeHeaders(Map<String, String>? extra) {
    return {
      'Accept': 'application/json',
      if (extra != null) ...extra,
    };
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? query,
    Map<String, String>? headers,
  }) async {
    final r = await http.get(
      _u(path, query),
      headers: _mergeHeaders(headers),
    );
    return _handle(r);
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> data, {
    Map<String, String>? headers,
  }) async {
    final allHeaders = _mergeHeaders({
      'Content-Type': 'application/json',
      if (headers != null) ...headers,
    });

    final r = await http.post(
      _u(path),
      headers: allHeaders,
      body: jsonEncode(data),
    );
    return _handle(r);
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    final r = await http.delete(
      _u(path),
      headers: _mergeHeaders(headers),
    );
    return _handle(r);
  }

  Map<String, dynamic> _handle(http.Response r) {
    final body = r.body.isEmpty ? {} : jsonDecode(r.body);

    final map = body is Map<String, dynamic> ? body : {'data': body};

    if (r.statusCode < 200 || r.statusCode >= 300) {
      if (map['message'] != null) throw Exception(map['message'].toString());

      if (map['errors'] is Map) {
        final errors = (map['errors'] as Map).values.expand((v) => v as List).toList();
        if (errors.isNotEmpty) throw Exception(errors.first.toString());
      }

      throw Exception('Request failed (${r.statusCode})');
    }

    return map;
  }
}