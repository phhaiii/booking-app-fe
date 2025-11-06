import 'dart:convert';
import 'dart:io';
import 'package:booking_app/models/venuedetail_response.dart';
import 'package:booking_app/service/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VenueService {
  // ============================================================================
  // VENUE/POST CRUD OPERATIONS
  // ============================================================================

  /// Get all published venues/posts with pagination
  static Future<Map<String, dynamic>?> getAllVenues({
    int page = 0,
    int size = 10,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}/posts?page=$page&size=$size&sortBy=$sortBy&sortDir=$sortDir',
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];
          final List<dynamic> content = data['content'] ?? [];

          return {
            'venues': content
                .map((item) => VenueDetailResponse.fromJson(item))
                .toList(),
            'totalPages': data['totalPages'] ?? 0,
            'totalElements': data['totalElements'] ?? 0,
            'currentPage': data['number'] ?? 0,
            'hasNext': !(data['last'] ?? true),
          };
        }
      }

      print('Failed to fetch venues: ${response.statusCode}');
      return null;
    } catch (e) {
      print('Error fetching venues: $e');
      return null;
    }
  }

  /// Get venue details by ID
  static Future<VenueDetailResponse?> getVenueDetails(String venueId) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/posts/$venueId');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          return VenueDetailResponse.fromJson(jsonData['data']);
        }
      }

      print('Failed to fetch venue details: ${response.statusCode}');
      return null;
    } catch (e) {
      print('Error fetching venue details: $e');
      return null;
    }
  }

  /// Get venues by vendor ID
  static Future<Map<String, dynamic>?> getVenuesByVendor(
    String vendorId, {
    int page = 0,
    int size = 10,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}/posts/vendor/$vendorId?page=$page&size=$size',
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];
          final List<dynamic> content = data['content'] ?? [];

          return {
            'venues': content
                .map((item) => VenueDetailResponse.fromJson(item))
                .toList(),
            'totalPages': data['totalPages'] ?? 0,
            'totalElements': data['totalElements'] ?? 0,
          };
        }
      }

      return null;
    } catch (e) {
      print('Error fetching vendor venues: $e');
      return null;
    }
  }

  // ============================================================================
  // FAVORITE OPERATIONS
  // ============================================================================

  /// Toggle favorite status for a venue
  static Future<Map<String, dynamic>> toggleFavorite(String venueId) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/posts/$venueId/favorite');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        return {
          'success': jsonData['success'] ?? false,
          'isFavorite': jsonData['data'] ?? false,
          'message': jsonData['message'] ?? '',
        };
      }

      return {
        'success': false,
        'isFavorite': false,
        'message': 'Failed to toggle favorite',
      };
    } catch (e) {
      print('Error toggling favorite: $e');
      return {
        'success': false,
        'isFavorite': false,
        'message': 'Error: $e',
      };
    }
  }

  /// Check if venue is in favorites
  static Future<bool> isFavorite(String venueId) async {
    try {
      final uri =
          Uri.parse('${ApiConstants.baseUrl}/posts/$venueId/favorite/status');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return jsonData['data'] == true;
      }

      return false;
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  /// Get all favorite venues
  static Future<Map<String, dynamic>?> getFavoriteVenues({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}/posts/favorites?page=$page&size=$size',
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];
          final List<dynamic> content = data['content'] ?? [];

          return {
            'venues': content
                .map((item) => VenueDetailResponse.fromJson(item))
                .toList(),
            'totalPages': data['totalPages'] ?? 0,
            'totalElements': data['totalElements'] ?? 0,
            'currentPage': data['number'] ?? 0,
          };
        }
      }

      return null;
    } catch (e) {
      print('Error fetching favorite venues: $e');
      return null;
    }
  }

  // ============================================================================
  // SEARCH & FILTER OPERATIONS
  // ============================================================================

  /// Search venues by keyword
  static Future<Map<String, dynamic>?> searchVenues(
    String keyword, {
    int page = 0,
    int size = 10,
  }) async {
    try {
      final encodedKeyword = Uri.encodeComponent(keyword);
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}/posts/search?keyword=$encodedKeyword&page=$page&size=$size',
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];
          final List<dynamic> content = data['content'] ?? [];

          return {
            'venues': content
                .map((item) => VenueDetailResponse.fromJson(item))
                .toList(),
            'totalPages': data['totalPages'] ?? 0,
            'totalElements': data['totalElements'] ?? 0,
            'currentPage': data['number'] ?? 0,
          };
        }
      }

      return null;
    } catch (e) {
      print('Error searching venues: $e');
      return null;
    }
  }

  /// Filter venues by price range
  static Future<Map<String, dynamic>?> filterByPriceRange({
    required double minPrice,
    required double maxPrice,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}/posts/filter/price?minPrice=$minPrice&maxPrice=$maxPrice&page=$page&size=$size',
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];
          final List<dynamic> content = data['content'] ?? [];

          return {
            'venues': content
                .map((item) => VenueDetailResponse.fromJson(item))
                .toList(),
            'totalPages': data['totalPages'] ?? 0,
            'totalElements': data['totalElements'] ?? 0,
          };
        }
      }

      return null;
    } catch (e) {
      print('Error filtering by price: $e');
      return null;
    }
  }

  /// Filter venues by minimum capacity
  static Future<Map<String, dynamic>?> filterByCapacity({
    required int minCapacity,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}/posts/filter/capacity?minCapacity=$minCapacity&page=$page&size=$size',
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];
          final List<dynamic> content = data['content'] ?? [];

          return {
            'venues': content
                .map((item) => VenueDetailResponse.fromJson(item))
                .toList(),
            'totalPages': data['totalPages'] ?? 0,
            'totalElements': data['totalElements'] ?? 0,
          };
        }
      }

      return null;
    } catch (e) {
      print('Error filtering by capacity: $e');
      return null;
    }
  }

  /// Filter venues by style
  static Future<Map<String, dynamic>?> filterByStyle({
    required String style,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final encodedStyle = Uri.encodeComponent(style);
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}/posts/filter/style?style=$encodedStyle&page=$page&size=$size',
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];
          final List<dynamic> content = data['content'] ?? [];

          return {
            'venues': content
                .map((item) => VenueDetailResponse.fromJson(item))
                .toList(),
            'totalPages': data['totalPages'] ?? 0,
            'totalElements': data['totalElements'] ?? 0,
          };
        }
      }

      return null;
    } catch (e) {
      print('Error filtering by style: $e');
      return null;
    }
  }

  /// Get popular venues (sorted by view count)
  static Future<Map<String, dynamic>?> getPopularVenues({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}/posts/popular?page=$page&size=$size',
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];
          final List<dynamic> content = data['content'] ?? [];

          return {
            'venues': content
                .map((item) => VenueDetailResponse.fromJson(item))
                .toList(),
            'totalPages': data['totalPages'] ?? 0,
            'totalElements': data['totalElements'] ?? 0,
          };
        }
      }

      return null;
    } catch (e) {
      print('Error fetching popular venues: $e');
      return null;
    }
  }

  /// Get trending venues (sorted by booking count)
  static Future<Map<String, dynamic>?> getTrendingVenues({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}/posts/trending?page=$page&size=$size',
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];
          final List<dynamic> content = data['content'] ?? [];

          return {
            'venues': content
                .map((item) => VenueDetailResponse.fromJson(item))
                .toList(),
            'totalPages': data['totalPages'] ?? 0,
            'totalElements': data['totalElements'] ?? 0,
          };
        }
      }

      return null;
    } catch (e) {
      print('Error fetching trending venues: $e');
      return null;
    }
  }

  // ============================================================================
  // COMMENT/REVIEW OPERATIONS
  // ============================================================================

  /// Get venue comments/reviews with pagination
  static Future<Map<String, dynamic>?> getVenueComments(
    String venueId, {
    int page = 0,
    int size = 10,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}/comments/post/$venueId?page=$page&size=$size',
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];
          final List<dynamic> content = data['content'] ?? [];

          return {
            'comments':
                content.map((item) => VenueComment.fromJson(item)).toList(),
            'totalPages': data['totalPages'] ?? 0,
            'totalElements': data['totalElements'] ?? 0,
            'currentPage': data['number'] ?? 0,
            'averageRating': data['averageRating'] ?? 0.0,
          };
        }
      }

      return null;
    } catch (e) {
      print('Error fetching comments: $e');
      return null;
    }
  }

  /// Add a new comment/review
  static Future<VenueComment?> addComment(
    String venueId, {
    required String content,
    required double rating,
    List<String>? imagePaths,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.baseUrl}/comments'),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer ${await _getAuthToken()}',
      });

      // Add fields
      request.fields['postId'] = venueId;
      request.fields['content'] = content;
      request.fields['rating'] = rating.toString();

      // Add images if provided
      if (imagePaths != null && imagePaths.isNotEmpty) {
        for (var imagePath in imagePaths) {
          final file = File(imagePath);
          if (await file.exists()) {
            var multipartFile = await http.MultipartFile.fromPath(
              'images',
              file.path,
              contentType: MediaType('image', 'jpeg'),
            );
            request.files.add(multipartFile);
          }
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          return VenueComment.fromJson(jsonData['data']);
        }
      }

      print('Failed to add comment: ${response.statusCode}');
      return null;
    } catch (e) {
      print('Error adding comment: $e');
      return null;
    }
  }

  /// Update an existing comment
  static Future<VenueComment?> updateComment(
    String commentId, {
    required String content,
    required double rating,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/comments/$commentId');

      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
        body: json.encode({
          'content': content,
          'rating': rating,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          return VenueComment.fromJson(jsonData['data']);
        }
      }

      return null;
    } catch (e) {
      print('Error updating comment: $e');
      return null;
    }
  }

  /// Delete a comment
  static Future<bool> deleteComment(String commentId) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/comments/$commentId');

      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting comment: $e');
      return false;
    }
  }

  /// Like a comment
  static Future<bool> likeComment(String commentId) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/comments/$commentId/like');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error liking comment: $e');
      return false;
    }
  }

  // ============================================================================
  // VENDOR OPERATIONS (FOR VENDOR ROLE)
  // ============================================================================

  /// Create a new venue/post (Vendor only)
  static Future<VenueDetailResponse?> createVenue({
    required String title,
    required String description,
    required String content,
    required String location,
    required double price,
    required int capacity,
    required List<String> imagePaths,
    required List<String> amenities,
    required String style,
    bool allowComments = true,
    bool enableNotifications = true,
    List<Map<String, dynamic>>? menuItems, // ✅ THÊM parameter này
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.baseUrl}/posts'),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer ${await _getAuthToken()}',
      });

      // Add fields
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['content'] = content;
      request.fields['location'] = location;
      request.fields['price'] = price.toString();
      request.fields['capacity'] = capacity.toString();
      request.fields['allowComments'] = allowComments.toString();
      request.fields['enableNotifications'] = enableNotifications.toString();
      request.fields['style'] = style;

      // Add amenities as JSON array
      request.fields['amenities'] = jsonEncode(amenities);

      // ✅ THÊM: Add menu items as JSON array
      if (menuItems != null && menuItems.isNotEmpty) {
        request.fields['menuItems'] = jsonEncode(menuItems);
      }

      // Add images
      for (var imagePath in imagePaths) {
        final file = File(imagePath);
        if (await file.exists()) {
          var multipartFile = await http.MultipartFile.fromPath(
            'images',
            file.path,
            contentType: MediaType('image', 'jpeg'),
          );
          request.files.add(multipartFile);
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          return VenueDetailResponse.fromJson(jsonData['data']);
        }
      }

      print('Failed to create venue: ${response.statusCode}');
      print('Response: ${response.body}');
      return null;
    } catch (e) {
      print('Error creating venue: $e');
      return null;
    }
  }

  /// Update venue (Vendor only)
  static Future<VenueDetailResponse?> updateVenue(
    String venueId, {
    String? title,
    String? description,
    String? content,
    String? location,
    double? price,
    int? capacity,
    List<String>? newImagePaths,
    List<String>? existingImageUrls,
    List<String>? amenities,
    String? style,
    bool? allowComments,
    bool? enableNotifications,
  }) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${ApiConstants.baseUrl}/posts/$venueId'),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer ${await _getAuthToken()}',
      });

      // Add fields (only if provided)
      if (title != null) request.fields['title'] = title;
      if (description != null) request.fields['description'] = description;
      if (content != null) request.fields['content'] = content;
      if (location != null) request.fields['location'] = location;
      if (price != null) request.fields['price'] = price.toString();
      if (capacity != null) request.fields['capacity'] = capacity.toString();
      if (style != null) request.fields['style'] = style;
      if (allowComments != null) {
        request.fields['allowComments'] = allowComments.toString();
      }
      if (enableNotifications != null) {
        request.fields['enableNotifications'] = enableNotifications.toString();
      }

      if (amenities != null) {
        request.fields['amenities'] = json.encode(amenities);
      }

      if (existingImageUrls != null) {
        request.fields['existingImages'] = json.encode(existingImageUrls);
      }

      // Add new images
      if (newImagePaths != null) {
        for (var imagePath in newImagePaths) {
          final file = File(imagePath);
          if (await file.exists()) {
            var multipartFile = await http.MultipartFile.fromPath(
              'newImages',
              file.path,
              contentType: MediaType('image', 'jpeg'),
            );
            request.files.add(multipartFile);
          }
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          return VenueDetailResponse.fromJson(jsonData['data']);
        }
      }

      print('Failed to update venue: ${response.statusCode}');
      return null;
    } catch (e) {
      print('Error updating venue: $e');
      return null;
    }
  }

  /// Delete venue (Vendor only)
  static Future<bool> deleteVenue(String venueId) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/posts/$venueId');

      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting venue: $e');
      return false;
    }
  }

  /// Get my venues (Vendor only)
  static Future<Map<String, dynamic>?> getMyVenues({
    int page = 0,
    int size = 10,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}/posts/my-posts?page=$page&size=$size&sortBy=$sortBy&sortDir=$sortDir',
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];
          final List<dynamic> content = data['content'] ?? [];

          return {
            'venues': content
                .map((item) => VenueDetailResponse.fromJson(item))
                .toList(),
            'totalPages': data['totalPages'] ?? 0,
            'totalElements': data['totalElements'] ?? 0,
            'currentPage': data['number'] ?? 0,
          };
        }
      }

      return null;
    } catch (e) {
      print('Error fetching my venues: $e');
      return null;
    }
  }

  /// Get venue statistics (Vendor only)
  static Future<Map<String, dynamic>?> getVenueStatistics(
      String venueId) async {
    try {
      final uri =
          Uri.parse('${ApiConstants.baseUrl}/posts/$venueId/statistics');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          return jsonData['data'];
        }
      }

      return null;
    } catch (e) {
      print('Error fetching venue statistics: $e');
      return null;
    }
  }

  /// Get vendor statistics (Vendor only)
  static Future<Map<String, dynamic>?> getVendorStatistics() async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/posts/statistics/vendor');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getAuthToken()}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          return jsonData['data'];
        }
      }

      return null;
    } catch (e) {
      print('Error fetching vendor statistics: $e');
      return null;
    }
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get authentication token from secure storage
  static Future<String> _getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token') ?? '';
    } catch (e) {
      print('Error getting auth token: $e');
      return '';
    }
  }

  /// Save authentication token to secure storage
  static Future<void> saveAuthToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    } catch (e) {
      print('Error saving auth token: $e');
    }
  }

  /// Clear authentication token
  static Future<void> clearAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } catch (e) {
      print('Error clearing auth token: $e');
    }
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await _getAuthToken();
    return token.isNotEmpty;
  }
}

// ============================================================================
// ✅ SỬA: ĐỔI TÊN CLASS COMMENT THÀNH VENUECOMMENT
// ============================================================================

class VenueComment {
  final String id;
  final String content;
  final double rating;
  final String userId;
  final String userName;
  final String? userAvatar;
  final List<String> images;
  final int likeCount;
  final bool isLiked;
  final DateTime createdAt;
  final DateTime? updatedAt;

  VenueComment({
    required this.id,
    required this.content,
    required this.rating,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.images,
    required this.likeCount,
    required this.isLiked,
    required this.createdAt,
    this.updatedAt,
  });

  factory VenueComment.fromJson(Map<String, dynamic> json) {
    return VenueComment(
      id: json['id']?.toString() ?? '',
      content: json['content'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      userId: json['userId']?.toString() ?? '',
      userName: json['userName'] ?? '',
      userAvatar: json['userAvatar'],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      likeCount: json['likeCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'rating': rating,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'images': images,
      'likeCount': likeCount,
      'isLiked': isLiked,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // ✅ Helper method để format date
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} năm trước';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} tháng trước';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
}
