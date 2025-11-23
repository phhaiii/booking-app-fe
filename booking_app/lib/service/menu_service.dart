import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:booking_app/service/storage_service.dart';
import 'package:booking_app/model/menu_model.dart';

class MenuService {
  static const String baseUrl = 'http://10.0.2.2:8089/api';

  /// ✅ Get headers with auth token
  static Future<Map<String, String>> _getHeaders() async {
    final token = await StorageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ═══════════════════════════════════════════════
  // 📝 CREATE MENU
  // ═══════════════════════════════════════════════

  /// Create menu for a post
  static Future<MenuModel?> createMenu({
    required int postId,
    required String name,
    required String description,
    required double price,
    required int guestsPerTable,
    required List<String> items,
  }) async {
    try {
      print('═══════════════════════════════════════');
      print('CREATING MENU');
      print('Post ID: $postId');
      print('Name: $name');
      print('Price: $price');
      print('Guests per table: $guestsPerTable');
      print('═══════════════════════════════════════');

      final url = '$baseUrl/posts/$postId/menus';
      print('URL: $url');

      // Calculate pricePerPerson
      final pricePerPerson = guestsPerTable > 0 ? price / guestsPerTable : 0.0;

      final requestBody = {
        'name': name,
        'description': description,
        'price': price,
        'pricePerPerson': pricePerPerson,
        'guestsPerTable': guestsPerTable,
        'items': items,
      };

      print('Request Body: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse(url),
        headers: await _getHeaders(),
        body: json.encode(requestBody),
      );

      print('Response: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('═══════════════════════════════════════');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        print('Response JSON: $jsonData');
        print('Success: ${jsonData['success']}');
        print('Data: ${jsonData['data']}');
        print('Message: ${jsonData['message']}');

        if (jsonData['success'] == true && jsonData['data'] != null) {
          print('Menu created successfully');
          print('Menu data: ${jsonData['data']}');
          return MenuModel.fromJson(jsonData['data']);
        } else {
          print('Success is false or data is null');
        }
      } else if (response.statusCode == 400) {
        print('BAD REQUEST (400)');
        print('Response: ${response.body}');
        try {
          final errorData = json.decode(response.body);
          print('Error message: ${errorData['message']}');
        } catch (e) {
          print('Cannot parse error response');
        }
      } else if (response.statusCode == 403) {
        print('FORBIDDEN (403) - Authorization failed');
        print('Response: ${response.body}');
      } else if (response.statusCode == 401) {
        print('UNAUTHORIZED (401) - Token missing or invalid');
        print('Response: ${response.body}');
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response: ${response.body}');
      }

      print('Failed to create menu');
      print('═══════════════════════════════════════');
      return null;
    } catch (e) {
      print('Error creating menu: $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════
  // 🔍 GET MENUS BY POST
  // ═══════════════════════════════════════════════

  /// Get all menus for a post
  static Future<List<MenuModel>> getMenusByPost(int postId) async {
    try {
      print('═══════════════════════════════════════');
      print('Fetching menus for post: $postId');
      print('═══════════════════════════════════════');

      final url = '$baseUrl/posts/$postId/menus';
      print('URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      print('Response: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('═══════════════════════════════════════');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('JSON Structure: ${jsonData.keys}');
        print('Success: ${jsonData['success']}');
        print('Data: ${jsonData['data']}');

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> menusJson = jsonData['data'];
          print('Found ${menusJson.length} menus in response');

          if (menusJson.isEmpty) {
            print('WARNING: Backend returned empty menu list');
          } else {
            print('First menu: ${menusJson[0]}');
          }

          return menusJson.map((json) => MenuModel.fromJson(json)).toList();
        } else {
          print('Invalid response structure or data is null');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
      }

      return [];
    } catch (e, stackTrace) {
      print('Error fetching menus: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  // ═══════════════════════════════════════════════
  // ✏️ UPDATE MENU
  // ═══════════════════════════════════════════════

  /// Update existing menu
  static Future<MenuModel?> updateMenu({
    required int menuId,
    required String name,
    required String description,
    required double price,
    required int guestsPerTable,
    required List<String> items,
  }) async {
    try {
      print('Updating menu: $menuId');

      final url = '$baseUrl/menus/$menuId';

      // Calculate pricePerPerson
      final pricePerPerson = guestsPerTable > 0 ? price / guestsPerTable : 0.0;

      final requestBody = {
        'name': name,
        'description': description,
        'price': price,
        'pricePerPerson': pricePerPerson,
        'guestsPerTable': guestsPerTable,
        'items': items,
      };

      final response = await http.put(
        Uri.parse(url),
        headers: await _getHeaders(),
        body: json.encode(requestBody),
      );

      print('Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          print('Menu updated successfully');
          return MenuModel.fromJson(jsonData['data']);
        }
      }

      return null;
    } catch (e) {
      print('Error updating menu: $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════
  // 🗑️ DELETE MENU
  // ═══════════════════════════════════════════════

  /// Delete menu
  static Future<bool> deleteMenu(int menuId) async {
    try {
      print('Deleting menu: $menuId');

      final url = '$baseUrl/menus/$menuId';

      final response = await http.delete(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      print('Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('Menu deleted successfully');
        return jsonData['success'] == true;
      }

      return false;
    } catch (e) {
      print('Error deleting menu: $e');
      return false;
    }
  }
}
