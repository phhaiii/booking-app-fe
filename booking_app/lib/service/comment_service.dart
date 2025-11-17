import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:booking_app/service/storage_service.dart';
import 'package:booking_app/model/commentmodel.dart';
import 'api_constants.dart';

class CommentService {
  static const String baseUrl = '${ApiConstants.baseUrl}/api';

  // ✅ Get headers with authentication token
  static Future<Map<String, String>> _getHeaders() async {
    final token = await StorageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ✅ Get comments for a specific post
  static Future<CommentsResponse> getComments({
    required String postId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      print('🔄 Fetching comments for post: $postId (page: $page)');

      final uri = Uri.parse('$baseUrl/posts/$postId/comments')
          .replace(queryParameters: {
        'page': page.toString(),
        'size': size.toString(),
      });

      final response = await http.get(
        uri,
        headers: await _getHeaders(),
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        print('📦 Raw response keys: ${jsonData.keys.toList()}');

        // Handle different backend response formats
        Map<String, dynamic> responseData;

        if (jsonData is Map<String, dynamic>) {
          // Check if response has 'data' wrapper (ApiResponse<T> format)
          if (jsonData.containsKey('data')) {
            responseData = jsonData['data'] as Map<String, dynamic>;
            print('✅ Unwrapped data from ApiResponse');
            print('📦 Response data keys: ${responseData.keys.toList()}');
          } else {
            responseData = jsonData;
          }
        } else {
          throw Exception('Unexpected response format');
        }

        print('✅ Comments loaded successfully');
        print('📊 averageRating: ${responseData['averageRating']}');
        print('📊 totalComments: ${responseData['totalComments']}');
        print('📊 Total elements: ${responseData['totalElements']}');

        return CommentsResponse.fromJson(responseData);
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        print('❌ Failed to load comments: ${response.statusCode}');
        print('❌ Error body: $errorBody');
        throw Exception('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading comments: $e');
      rethrow;
    }
  }

  // ✅ Create a new comment
  static Future<Comment> createComment({
    required String postId,
    required String content,
    required double rating,
  }) async {
    try {
      print('🔄 Creating comment for post: $postId');
      print('   Rating: $rating');
      print('   Content length: ${content.length}');

      final token = await StorageService.getToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final uri = Uri.parse('$baseUrl/posts/$postId/comments');

      // ✅ Use multipart/form-data (backend expects @RequestParam with file upload support)
      var request = http.MultipartRequest('POST', uri);

      // Add headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Add fields
      request.fields['content'] = content;
      request.fields['rating'] = rating.toString();

      print('📤 Sending multipart request...');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        print('✅ Comment created successfully');

        // Handle both direct comment response and wrapped data response
        if (jsonData['data'] != null) {
          return Comment.fromJson(jsonData['data']);
        } else {
          return Comment.fromJson(jsonData);
        }
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        print('❌ Failed to create comment: ${response.statusCode}');
        print('   Error: $errorBody');

        // Parse error message from backend
        try {
          final errorJson = json.decode(errorBody);
          final errorMessage = errorJson['message'] ??
              'Failed to create comment: ${response.statusCode}';
          throw Exception(errorMessage);
        } catch (e) {
          if (e.toString().contains('Exception:')) {
            rethrow;
          }
          throw Exception('Failed to create comment: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('❌ Error creating comment: $e');

      // Clean up error message
      String errorMsg = e.toString();
      if (errorMsg.startsWith('Exception: Exception: ')) {
        errorMsg = errorMsg.substring('Exception: '.length);
      }
      throw Exception(errorMsg);
    }
  }

  // ✅ Update a comment
  static Future<Comment> updateComment({
    required String postId,
    required String commentId,
    required String content,
    required double rating,
  }) async {
    try {
      print('🔄 Updating comment: $commentId');

      final uri = Uri.parse('$baseUrl/posts/$postId/comments/$commentId');

      final response = await http.put(
        uri,
        headers: await _getHeaders(),
        body: json.encode({
          'content': content,
          'rating': rating,
        }),
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        print('✅ Comment updated successfully');
        return Comment.fromJson(jsonData);
      } else {
        print('❌ Failed to update comment: ${response.statusCode}');
        throw Exception('Failed to update comment: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error updating comment: $e');
      throw Exception('Error updating comment: $e');
    }
  }

  // ✅ Delete a comment
  static Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      print('🔄 Deleting comment: $commentId');

      final uri = Uri.parse('$baseUrl/posts/$postId/comments/$commentId');

      final response = await http.delete(
        uri,
        headers: await _getHeaders(),
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Comment deleted successfully');
      } else {
        print('❌ Failed to delete comment: ${response.statusCode}');
        throw Exception('Failed to delete comment: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error deleting comment: $e');
      throw Exception('Error deleting comment: $e');
    }
  }

  // ✅ Mark comment as helpful
  static Future<void> markAsHelpful({
    required String postId,
    required String commentId,
  }) async {
    try {
      print('🔄 Marking comment as helpful: $commentId');

      final uri =
          Uri.parse('$baseUrl/posts/$postId/comments/$commentId/helpful');

      final response = await http.post(
        uri,
        headers: await _getHeaders(),
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Comment marked as helpful');
      } else {
        print('❌ Failed to mark comment as helpful: ${response.statusCode}');
        throw Exception(
            'Failed to mark comment as helpful: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error marking comment as helpful: $e');
      throw Exception('Error marking comment as helpful: $e');
    }
  }

  // ✅ Get comment statistics
  static Future<Map<String, dynamic>> getCommentStatistics({
    required String postId,
  }) async {
    try {
      print('🔄 Fetching comment statistics for post: $postId');

      final uri = Uri.parse('$baseUrl/posts/$postId/comments/statistics');

      final response = await http.get(
        uri,
        headers: await _getHeaders(),
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        print('✅ Statistics loaded successfully');
        return jsonData;
      } else {
        print('❌ Failed to load statistics: ${response.statusCode}');
        throw Exception('Failed to load statistics: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading statistics: $e');
      throw Exception('Error loading statistics: $e');
    }
  }
}
