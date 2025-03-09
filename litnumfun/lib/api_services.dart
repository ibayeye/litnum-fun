import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // Fungsi umum untuk request HTTP
  Future<dynamic> request({
    required String endpoint,
    String method = 'GET',
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final defaultHeaders = {"Content-Type": "application/json"};

    try {
      http.Response response;

      // Pilih metode HTTP sesuai request
      switch (method.toUpperCase()) {
        case 'POST':
          response = await http.post(
            url,
            headers: {...defaultHeaders, ...?headers},
            body: jsonEncode(body),
          );
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: {...defaultHeaders, ...?headers},
            body: jsonEncode(body),
          );
          break;
        case 'DELETE':
          response = await http.delete(
            url,
            headers: {...defaultHeaders, ...?headers},
          );
          break;
        default:
          response = await http.get(
            url,
            headers: {...defaultHeaders, ...?headers},
          );
      }

      // Cek status response
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Request failed', 'status': response.statusCode};
      }
    } catch (e) {
      return {'error': 'Failed to connect', 'message': e.toString()};
    }
  }
}
