import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Địa chỉ backend của bạn
  // Để test trên Android Emulator: dùng 10.0.2.2 thay vì localhost
  // Để test trên thiết bị thật: dùng IP máy tính (vd: 192.168.1.100)
  static const String baseUrl = 'http://10.0.2.2:8088/api';

  // Hoặc nếu backend deploy online:
  // static const String baseUrl = 'https://your-domain.com/api';

  // Headers mặc định
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // GET request
  static Future<dynamic> get(String endpoint,
      {Map<String, String>? customHeaders}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: customHeaders ?? headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // POST request
  static Future<dynamic> post(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? customHeaders,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: customHeaders ?? headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // PUT request
  static Future<dynamic> put(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? customHeaders,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: customHeaders ?? headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // DELETE request
  static Future<dynamic> delete(String endpoint,
      {Map<String, String>? customHeaders}) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: customHeaders ?? headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // Xử lý response
  static dynamic _handleResponse(http.Response response) {
    if (response.body.isEmpty) {
      throw Exception('Server không trả về dữ liệu');
    }

    try {
      final jsonResponse = jsonDecode(response.body);

      switch (response.statusCode) {
        case 200:
        case 201:
          return jsonResponse;
        case 400:
          // Bad Request - lấy message từ response nếu có
          final message = jsonResponse['message'] ?? 'Yêu cầu không hợp lệ';
          throw Exception(message);
        case 401:
          final message =
              jsonResponse['message'] ?? 'Phiên đăng nhập đã hết hạn';
          throw Exception(message);
        case 403:
          final message = jsonResponse['message'] ?? 'Không có quyền truy cập';
          throw Exception(message);
        case 404:
          final message =
              jsonResponse['message'] ?? 'Không tìm thấy tài nguyên';
          throw Exception(message);
        case 500:
          final message = jsonResponse['message'] ?? 'Lỗi máy chủ nội bộ';
          throw Exception(message);
        default:
          final message = jsonResponse['message'] ?? 'Lỗi không xác định';
          throw Exception('$message (${response.statusCode})');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Lỗi xử lý dữ liệu từ server');
    }
  }

  // POST request với authentication token
  static Future<dynamic> postWithAuth(
    String endpoint, {
    required Map<String, dynamic> body,
    required String token,
  }) async {
    final authHeaders = {
      ...headers,
      'Authorization': 'Bearer $token',
    };
    return post(endpoint, body: body, customHeaders: authHeaders);
  }

  // GET request với authentication token
  static Future<dynamic> getWithAuth(
    String endpoint, {
    required String token,
  }) async {
    final authHeaders = {
      ...headers,
      'Authorization': 'Bearer $token',
    };
    return get(endpoint, customHeaders: authHeaders);
  }
}

