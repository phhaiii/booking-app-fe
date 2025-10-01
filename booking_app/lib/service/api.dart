import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Change this to your actual backend URL
  static const String baseUrl = "http://localhost:8088/api";  // Android Emulator

  

  // Login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "email": email, 
          "password": password
        }),
      );

      print('Login Response Status: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'token': data["token"],
          'user': data["user"], // if your backend returns user data
          'message': 'Login successful'
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Login failed',
          'error': response.body
        };
      }
    } catch (e) {
      print('Login Error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
        'error': e.toString()
      };
    }
  }

  // Register
  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "password": password,
          "phone": phone,
        }),
      );

      print('Register Response Status: ${response.statusCode}');
      print('Register Response Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': 'Registration successful',
          'data': data
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Registration failed',
          'error': response.body
        };
      }
    } catch (e) {
      print('Register Error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
        'error': e.toString()
      };
    }
  }

  // Get Users (with token)
  static Future<Map<String, dynamic>> getUsers(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      print('Get Users Response Status: ${response.statusCode}');
      print('Get Users Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'users': data,
          'message': 'Users loaded successfully'
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to load users',
          'error': response.body
        };
      }
    } catch (e) {
      print('Get Users Error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
        'error': e.toString()
      };
    }
  }

  // Test connection
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'), // Add health check endpoint in your backend
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }
}