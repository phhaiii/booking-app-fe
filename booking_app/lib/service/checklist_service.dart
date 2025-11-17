import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:booking_app/response/checklist_response.dart';
import 'package:booking_app/service/storage_service.dart';

class CheckListService {
  static const String baseUrl = 'http://10.0.2.2:8089/api/checklists';

  // ✅ Headers với Authorization token
  Future<Map<String, String>> getHeaders() async {
    // ✅ Gọi trực tiếp từ class, không qua instance
    final token = await StorageService.getToken();

    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ✅ GET ALL với authentication
  Future<List<CheckListItem>> getAll() async {
    try {
      print('[GET] $baseUrl');

      final headers = await getHeaders();
      final response = await http
          .get(Uri.parse(baseUrl), headers: headers)
          .timeout(const Duration(seconds: 10));

      print('📥 Response ${response.statusCode}: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => CheckListItem.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error in getAll: $e');
      rethrow;
    }
  }

  // ✅ CREATE với authentication
  Future<CheckListItem> create(CheckListItem item) async {
    try {
      final requestBody = {
        'title': item.title,
        'description': item.description,
      };

      print('[POST] $baseUrl');
      print('Body: ${json.encode(requestBody)}');

      final headers = await getHeaders();
      final response = await http
          .post(
            Uri.parse(baseUrl),
            headers: headers,
            body: json.encode(requestBody),
          )
          .timeout(const Duration(seconds: 10));

      print('📥 Response ${response.statusCode}: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CheckListItem.fromJson(
          json.decode(utf8.decode(response.bodyBytes)),
        );
      } else if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error in create: $e');
      rethrow;
    }
  }

  // ✅ UPDATE với authentication
  Future<CheckListItem> update(String id, CheckListItem item) async {
    try {
      final requestBody = {
        'title': item.title,
        'description': item.description,
      };

      final url = '$baseUrl/$id';
      print('[PUT] $url');
      print('Body: ${json.encode(requestBody)}');

      final headers = await getHeaders();
      final response = await http
          .put(
            Uri.parse(url),
            headers: headers,
            body: json.encode(requestBody),
          )
          .timeout(const Duration(seconds: 10));

      print('📥 Response ${response.statusCode}: ${response.body}');

      if (response.statusCode == 200) {
        return CheckListItem.fromJson(
          json.decode(utf8.decode(response.bodyBytes)),
        );
      } else if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error in update: $e');
      rethrow;
    }
  }

  // ✅ DELETE với authentication
  Future<void> delete(String id) async {
    try {
      final url = '$baseUrl/$id';
      print('[DELETE] $url');

      final headers = await getHeaders();
      final response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));

      print('Response ${response.statusCode}');

      if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      } else if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error in delete: $e');
      rethrow;
    }
  }

  // ✅ TOGGLE với authentication
  Future<CheckListItem> toggleCompleted(String id) async {
    try {
      final url = '$baseUrl/$id/toggle';
      print('[PATCH] $url');

      final headers = await getHeaders();
      final response = await http
          .patch(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));

      print('📥 Response ${response.statusCode}: ${response.body}');

      if (response.statusCode == 200) {
        return CheckListItem.fromJson(
          json.decode(utf8.decode(response.bodyBytes)),
        );
      } else if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error in toggle: $e');
      rethrow;
    }
  }

  // ✅ GET STATISTICS với authentication
  Future<Map<String, int>> getStatistics() async {
    try {
      final url = '$baseUrl/statistics';
      print('[GET] $url');

      final headers = await getHeaders();
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));

      print('📥 Response ${response.statusCode}: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(utf8.decode(response.bodyBytes));
        return {
          'completed': (data['completed'] as num).toInt(),
          'incomplete': (data['incomplete'] as num).toInt(),
          'total': (data['total'] as num).toInt(),
        };
      } else if (response.statusCode == 401) {
        throw Exception('Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.');
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error in getStatistics: $e');
      rethrow;
    }
  }
}
