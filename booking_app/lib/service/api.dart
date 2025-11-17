import 'package:booking_app/service/api_constants.dart';
import 'package:booking_app/service/storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ============================================================================
// API SERVICE
// ============================================================================
class ApiService {
  static const String baseUrl = '${ApiConstants.baseUrl}/api';

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  static Future<Map<String, String>> get authHeaders async {
    final token = await StorageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ✅ GET request - queryParameters is optional
  static Future<dynamic> get(
    String endpoint, {
    Map<String, String>? customHeaders,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final headers = customHeaders ?? await authHeaders;

      final uri = queryParameters != null && queryParameters.isNotEmpty
          ? Uri.parse('$baseUrl$endpoint')
              .replace(queryParameters: queryParameters)
          : Uri.parse('$baseUrl$endpoint');

      print('GET Request: $uri');
      print('Headers: $headers');

      final response = await http.get(uri, headers: headers);

      print('GET Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('GET Error: $e');
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // ✅ POST request (with auto auth)
  static Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? customHeaders,
  }) async {
    try {
      final headers = customHeaders ?? await authHeaders;

      print('POST Request: $baseUrl$endpoint');
      print('Headers: $headers');
      print('Body: ${body != null ? jsonEncode(body) : 'null'}');

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );

      print('POST Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('POST Error: $e');
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // ✅ POST request with explicit token (for logout)
  static Future<dynamic> postWithAuth(
    String endpoint, {
    required Map<String, dynamic> body,
    required String token,
  }) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      print('POST With Auth Request: $baseUrl$endpoint');
      print('Headers: $headers');
      print('Body: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );

      print('POST With Auth Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('POST With Auth Error: $e');
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // ✅ POST request without authentication (for login/register)
  static Future<dynamic> postNoAuth(
    String endpoint, {
    required Map<String, dynamic> body,
  }) async {
    try {
      print('POST No Auth Request: $baseUrl$endpoint');
      print('Body: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );

      print('POST No Auth Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('POST No Auth Error: $e');
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // PUT request
  static Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? customHeaders,
  }) async {
    try {
      final headers = customHeaders ?? await authHeaders;

      print('PUT Request: $baseUrl$endpoint');
      print('Headers: $headers');
      print('Body: ${body != null ? jsonEncode(body) : 'null'}');

      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );

      print('PUT Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('PUT Error: $e');
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // DELETE request
  static Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? customHeaders,
  }) async {
    try {
      final headers = customHeaders ?? await authHeaders;

      print('DELETE Request: $baseUrl$endpoint');
      print('Headers: $headers');

      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );

      print('DELETE Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      print('DELETE Error: $e');
      throw Exception('Lỗi kết nối: $e');
    }
  }

  static dynamic _handleResponse(http.Response response) {
    print('Processing response: ${response.statusCode}');

    if (response.body.isEmpty) {
      print('Empty response body');
      throw Exception('Server không trả về dữ liệu');
    }

    try {
      final jsonResponse = jsonDecode(response.body);
      print('JSON decoded successfully');

      switch (response.statusCode) {
        case 200:
        case 201:
          return jsonResponse;
        case 400:
          final message = jsonResponse['message'] ?? 'Yêu cầu không hợp lệ';
          print('Bad Request: $message');
          throw Exception(message);
        case 401:
          final message =
              jsonResponse['message'] ?? 'Phiên đăng nhập đã hết hạn';
          print('Unauthorized: $message');
          throw Exception(message);
        case 403:
          final message = jsonResponse['message'] ?? 'Không có quyền truy cập';
          print('Forbidden: $message');
          throw Exception(message);
        case 404:
          final message =
              jsonResponse['message'] ?? 'Không tìm thấy tài nguyên';
          print('Not Found: $message');
          throw Exception(message);
        case 500:
          final message = jsonResponse['message'] ?? 'Lỗi máy chủ nội bộ';
          print('Server Error: $message');
          throw Exception(message);
        default:
          final message = jsonResponse['message'] ?? 'Lỗi không xác định';
          print('Unknown Error: $message (${response.statusCode})');
          throw Exception('$message (${response.statusCode})');
      }
    } catch (e) {
      print('💥 JSON decode error: $e');
      if (e is Exception) rethrow;
      throw Exception('Lỗi xử lý dữ liệu từ server');
    }
  }

  // Test connection
  static Future<bool> testConnection() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/health'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      print('🚨 Connection test failed: $e');
      return false;
    }
  }
}
