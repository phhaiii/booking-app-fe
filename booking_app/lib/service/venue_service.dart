import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:booking_app/service/storage_service.dart';
import 'package:booking_app/response/venuedetail_response.dart';
import 'package:booking_app/utils/helpers/role_helper.dart';
import 'api_constants.dart';

class VenueService {
  // ✅ Base URL
  static const String baseUrl = 'http://10.0.2.2:8089/api';

  // ✅ Headers helper
  static Future<Map<String, String>> _getHeaders() async {
    final token = await StorageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // =====================================================
  // 🔐 PERMISSION HELPERS - USING RoleHelper
  // =====================================================

  /// ✅ Check if current user can create posts
  static Future<bool> canCreatePost() async {
    return await RoleHelper.canCreatePost();
  }

  /// ✅ Check if current user can edit specific post
  static Future<bool> canEditPost(String postOwnerId) async {
    return await RoleHelper.canEditPost(postOwnerId);
  }

  /// ✅ Check if current user can delete specific post
  static Future<bool> canDeletePost(String postOwnerId) async {
    return await RoleHelper.canDeletePost(postOwnerId);
  }

  /// ✅ Check if current user can manage bookings
  static Future<bool> canManageBookings() async {
    return await RoleHelper.canManageBookings();
  }

  /// ✅ Check if current user is admin
  static Future<bool> isAdmin() async {
    return await RoleHelper.isAdmin();
  }

  /// ✅ Check if current user is vendor
  static Future<bool> isVendor() async {
    return await RoleHelper.isVendor();
  }

  /// ✅ Check if current user is regular user
  static Future<bool> isUser() async {
    return await RoleHelper.isUser();
  }

  // =====================================================
  // 🔍 TEST CONNECTION
  // =====================================================

  static Future<bool> testConnection() async {
    try {
      print('═══════════════════════════════════════');
      print('TESTING BACKEND CONNECTION');
      print('═══════════════════════════════════════');
      print('URL: $baseUrl/posts');

      final uri = Uri.parse('$baseUrl/posts');
      print('  - Scheme: ${uri.scheme}');
      print('  - Host: ${uri.host}');
      print('  - Port: ${uri.port}');
      print('  - Path: ${uri.path}');

      final response = await http
          .get(
            uri,
            headers: await _getHeaders(),
          )
          .timeout(const Duration(seconds: 5));

      print('Response: ${response.statusCode}');
      print('═══════════════════════════════════════');

      final isOk = response.statusCode == 200 ||
          response.statusCode == 401 ||
          response.statusCode == 403;

      if (isOk) {
        print('✅ Backend is REACHABLE');
      } else {
        print('⚠️ Backend returned: ${response.statusCode}');
      }

      return isOk;
    } on TimeoutException catch (e) {
      print('═══════════════════════════════════════');
      print('CONNECTION TIMEOUT');
      print('═══════════════════════════════════════');
      print('Error: $e');
      return false;
    } catch (e) {
      print('═══════════════════════════════════════');
      print('CONNECTION ERROR');
      print('═══════════════════════════════════════');
      print('Error: $e');
      return false;
    }
  }

  // =====================================================
  // 🏢 VENUE/POST CRUD OPERATIONS
  // =====================================================

  /// ✅ Get all published venues (PUBLIC - No auth required)
  /// Accessible by: EVERYONE
  static Future<Map<String, dynamic>?> getAllVenues({
    int page = 0,
    int size = 10,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
  }) async {
    try {
      print('Fetching venues: page=$page, size=$size');

      final url =
          '$baseUrl/posts?page=$page&size=$size&sortBy=$sortBy&sortDir=$sortDir';
      print('URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['data'] != null) {
          final data = jsonData['data'];
          return {
            'venues': data['content'] ?? data['posts'] ?? [],
            'totalPages': data['totalPages'] ?? 0,
            'totalElements': data['totalElements'] ?? 0,
            'hasNext': data['hasNext'] ?? false,
            'currentPage': data['number'] ?? page,
          };
        }

        if (jsonData['content'] != null || jsonData['posts'] != null) {
          return {
            'venues': jsonData['content'] ?? jsonData['posts'] ?? [],
            'totalPages': jsonData['totalPages'] ?? 0,
            'totalElements': jsonData['totalElements'] ?? 0,
            'hasNext': jsonData['hasNext'] ?? false,
            'currentPage': jsonData['number'] ?? page,
          };
        }

        if (jsonData is List) {
          return {
            'venues': jsonData,
            'totalPages': 1,
            'totalElements': jsonData.length,
            'hasNext': false,
            'currentPage': 0,
          };
        }
      }

      print('❌ Unexpected response or error');
      return null;
    } catch (e, stackTrace) {
      print('Error fetching venues: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  /// ✅ Get venue detail by ID (PUBLIC)
  /// Accessible by: EVERYONE
  static Future<VenueDetailResponse> getVenueDetail(String venueId) async {
    try {
      print('Fetching venue: $venueId');

      // ✅ ĐÚNG: Có /api cho API endpoint
      final url = '${ApiConstants.baseUrl}/api/posts/$venueId';
      print('URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      print('📥 Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // ✅ Check response structure
        print('📄 Response structure: ${jsonData.keys}');

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final venueData = jsonData['data'];
          print('📄 Raw images: ${venueData['images']}');
          print('⭐ Rating: ${venueData['rating']}');
          print('📊 ReviewCount: ${venueData['reviewCount']}');
          print('💬 CommentCount: ${venueData['commentCount']}');

          // 🔍 DEBUG: Print toàn bộ venue data
          print('🔍 Full venue data keys: ${venueData.keys.toList()}');

          return VenueDetailResponse.fromJson(venueData);
        }

        throw Exception('Invalid response format');
      }

      throw Exception('Failed to load venue: ${response.statusCode}');
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // =====================================================
  // 🔍 SEARCH & FILTER (PUBLIC)
  // =====================================================

  /// ✅ Search venues by keyword (PUBLIC)
  /// Accessible by: EVERYONE
  static Future<Map<String, dynamic>?> searchVenues(
    String keyword, {
    int page = 0,
    int size = 20,
  }) async {
    try {
      print('Searching venues: "$keyword"');

      final url =
          '$baseUrl/posts/search?keyword=$keyword&page=$page&size=$size';
      print('URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];

          return {
            'venues': data['content'] ?? [],
            'totalElements': data['totalElements'] ?? 0,
            'totalPages': data['totalPages'] ?? 0,
            'currentPage': data['number'] ?? page,
          };
        }
      }

      return null;
    } catch (e) {
      print('Error searching venues: $e');
      return null;
    }
  }

  /// ✅ Filter by price range (PUBLIC)
  /// Accessible by: EVERYONE
  static Future<Map<String, dynamic>?> filterByPriceRange({
    required double minPrice,
    required double maxPrice,
    int page = 0,
    int size = 20,
  }) async {
    try {
      print('Filtering by price: $minPrice - $maxPrice');

      final url =
          '$baseUrl/posts/filter/price?minPrice=$minPrice&maxPrice=$maxPrice&page=$page&size=$size';
      print('📍 URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];

          return {
            'venues': data['content'] ?? [],
            'totalElements': data['totalElements'] ?? 0,
            'totalPages': data['totalPages'] ?? 0,
          };
        }
      }

      return null;
    } catch (e) {
      print('Error filtering by price: $e');
      return null;
    }
  }

  /// ✅ Filter by capacity (PUBLIC)
  /// Accessible by: EVERYONE
  static Future<Map<String, dynamic>?> filterByCapacity({
    required int minCapacity,
    int page = 0,
    int size = 20,
  }) async {
    try {
      print('👥 Filtering by capacity: min=$minCapacity');

      final url =
          '$baseUrl/posts/filter/capacity?minCapacity=$minCapacity&page=$page&size=$size';
      print('📍 URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];

          return {
            'venues': data['content'] ?? [],
            'totalElements': data['totalElements'] ?? 0,
            'totalPages': data['totalPages'] ?? 0,
            'currentPage': data['number'] ?? page,
          };
        }
      }

      print('⚠️ Failed to filter by capacity');
      return null;
    } catch (e) {
      print('Error filtering by capacity: $e');
      return null;
    }
  }

  // =====================================================
  // ❤️ FAVORITE/LIKE (AUTHENTICATED)
  // =====================================================

  /// ✅ Toggle favorite (like/unlike)
  /// Accessible by: USER, VENDOR, ADMIN (authenticated users)
  /// 🔒 REQUIRES: Authentication
  static Future<Map<String, dynamic>> toggleFavorite(String venueId) async {
    try {
      print('❤️ Toggling favorite for venue: $venueId');

      // ✅ Check authentication
      final token = await StorageService.getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'message': 'Vui lòng đăng nhập để thực hiện chức năng này',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/posts/$venueId/like'),
        headers: await _getHeaders(),
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true) {
          return {
            'success': true,
            'message': jsonData['message'] ?? 'Like toggled successfully',
            'isFavorite': true,
          };
        }
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại',
        };
      }

      return {
        'success': false,
        'message': 'Failed to toggle favorite',
      };
    } catch (e) {
      print('Error toggling favorite: $e');
      return {
        'success': false,
        'message': 'Lỗi: $e',
      };
    }
  }

  /// ✅ Get liked/favorited venues
  /// Accessible by: USER, VENDOR, ADMIN (authenticated users)
  /// 🔒 REQUIRES: Authentication
  static Future<Map<String, dynamic>?> getLikedVenues({
    int page = 0,
    int size = 20,
  }) async {
    try {
      print('❤️ Fetching liked venues...');

      // ✅ Check permission using RoleHelper
      final hasAuth = await RoleHelper.hasAnyRole([
        RoleHelper.ROLE_USER,
        RoleHelper.ROLE_VENDOR,
        RoleHelper.ROLE_ADMIN,
      ]);

      if (!hasAuth) {
        print('❌ User not authenticated');
        return null;
      }

      final url = '$baseUrl/posts/liked?page=$page&size=$size';
      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];

          return {
            'venues': data['content'] ?? [],
            'totalElements': data['totalElements'] ?? 0,
            'totalPages': data['totalPages'] ?? 0,
            'currentPage': data['number'] ?? page,
          };
        }
      }

      return null;
    } catch (e) {
      print('Error fetching liked venues: $e');
      return null;
    }
  }

  // =====================================================
  // 📝 CREATE POST (VENDOR/ADMIN ONLY)
  // =====================================================

  /// ✅ Create new venue/post
  /// Accessible by: VENDOR, ADMIN only
  /// 🔒 REQUIRES: VENDOR or ADMIN role
  static Future<Map<String, dynamic>?> createVenue({
    required String title,
    required String description,
    required String content,
    required String location,
    required double price,
    required int capacity,
    required List<String> imagePaths,
    required List<String> amenities,
    required String style,
    required bool allowComments,
    required bool enableNotifications,
    List<Map<String, dynamic>>? menuItems,
  }) async {
    try {
      print('═══════════════════════════════════════');
      print('🌐 CREATE VENUE - START');
      print('═══════════════════════════════════════');

      // ✅ CHECK PERMISSION
      /*
    final canCreate = await RoleHelper.canCreatePost();
    if (!canCreate) {
      print('❌ PERMISSION DENIED');
      return {
        'error': 'PERMISSION_DENIED',
        'message': 'Bạn không có quyền tạo bài đăng.',
      };
    }
    */

      // ✅ Get token
      final token = await StorageService.getToken();
      if (token == null || token.isEmpty) {
        print('❌ NO TOKEN');
        return {
          'error': 'NO_TOKEN',
          'message': 'Vui lòng đăng nhập lại.',
        };
      }

      // ✅ Build URL
      final uri = Uri.parse('$baseUrl/posts');
      print('📍 URL: $uri');

      // ✅ Create multipart request
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      // ✅ Add fields
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['content'] = content;
      request.fields['location'] = location;
      request.fields['price'] = price.toString();
      request.fields['capacity'] = capacity.toString();
      request.fields['style'] = style;
      request.fields['allowComments'] = allowComments.toString();
      request.fields['enableNotifications'] = enableNotifications.toString();

      // ✅ Add amenities as JSON string
      request.fields['amenities'] = json.encode(amenities);
      print('📦 Amenities: ${amenities.length} items');

      // ✅ Add menuItems as JSON string (OPTIONAL)
      if (menuItems != null && menuItems.isNotEmpty) {
        request.fields['menuItems'] = json.encode(menuItems);
        print('🍽️ Menu items: ${menuItems.length} sets');
      } else {
        print('⚠️ No menu items (optional)');
      }

      // ✅ Attach images
      print('📷 Attaching ${imagePaths.length} images...');
      for (int i = 0; i < imagePaths.length; i++) {
        try {
          final file = File(imagePaths[i]);

          // ✅ Check file exists
          if (!await file.exists()) {
            print('  [$i] ❌ File not found: ${imagePaths[i]}');
            continue;
          }

          final multipartFile = await http.MultipartFile.fromPath(
            'images',
            imagePaths[i],
          );

          request.files.add(multipartFile);
          print(
              '  [$i] ✅ ${multipartFile.length} bytes - ${multipartFile.filename}');
        } catch (e) {
          print('  [$i] ❌ Error: $e');
        }
      }

      // ✅ Check if any images attached
      if (request.files.isEmpty) {
        print('❌ NO IMAGES ATTACHED');
        return {
          'error': 'NO_IMAGES',
          'message': 'Không có ảnh nào được đính kèm.',
        };
      }

      // ✅ Send request
      print('═══════════════════════════════════════');
      print('🚀 SENDING REQUEST...');
      print('Fields: ${request.fields.keys.toList()}');
      print('Files: ${request.files.length}');
      print('═══════════════════════════════════════');

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60), // ✅ Tăng timeout lên 60s
        onTimeout: () {
          throw TimeoutException('Request timeout after 60 seconds');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');
      print('═══════════════════════════════════════');

      // ✅ Handle success response
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final jsonData = json.decode(response.body);

          print('✅ Response decoded successfully');
          print('Success: ${jsonData['success']}');

          if (jsonData['success'] == true && jsonData['data'] != null) {
            final postData = jsonData['data'] as Map<String, dynamic>;
            print('✅ Post ID: ${postData['id']}');
            print('✅ Post created successfully');
            return postData;
          } else {
            print('❌ Success = false or no data');
            return {
              'error': 'INVALID_RESPONSE',
              'message': jsonData['message'] ?? 'Unknown error',
            };
          }
        } catch (e) {
          print('❌ Error parsing response: $e');
          return {
            'error': 'PARSE_ERROR',
            'message': 'Lỗi parse response: $e',
            'body': response.body,
          };
        }
      }

      // ✅ Handle error responses
      else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        return {
          'error': 'BAD_REQUEST',
          'message': errorData['message'] ?? 'Dữ liệu không hợp lệ',
        };
      } else if (response.statusCode == 401) {
        return {
          'error': 'UNAUTHORIZED',
          'message': 'Phiên đăng nhập hết hạn.',
        };
      } else if (response.statusCode == 403) {
        return {
          'error': 'FORBIDDEN',
          'message': 'Bạn không có quyền thực hiện.',
        };
      } else if (response.statusCode == 500) {
        return {
          'error': 'SERVER_ERROR',
          'message': 'Lỗi server. Vui lòng thử lại sau.',
        };
      }

      print('❌ Unexpected status: ${response.statusCode}');
      return {
        'error': 'UNKNOWN_ERROR',
        'message': 'Lỗi không xác định (${response.statusCode})',
      };
    } on TimeoutException catch (e) {
      print('❌ TIMEOUT: $e');
      return {
        'error': 'TIMEOUT',
        'message': 'Kết nối quá lâu. Vui lòng thử lại.',
      };
    } on SocketException catch (e) {
      print('❌ NETWORK ERROR: $e');
      return {
        'error': 'NETWORK_ERROR',
        'message': 'Lỗi kết nối mạng.',
      };
    } catch (e, stackTrace) {
      print('❌ UNEXPECTED ERROR: $e');
      print('Stack trace: $stackTrace');
      return {
        'error': 'UNEXPECTED_ERROR',
        'message': 'Lỗi không mong muốn: $e',
      };
    }
  }

  // ✅ Helper: Get HTTP status text
  static String _getStatusText(int statusCode) {
    switch (statusCode) {
      case 200:
        return 'OK';
      case 201:
        return 'Created';
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not Found';
      case 500:
        return 'Internal Server Error';
      default:
        return 'Unknown';
    }
  }

  // =====================================================
  // 📝 UPDATE/DELETE POST (VENDOR/ADMIN ONLY)
  // =====================================================

  /// ✅ Update existing venue/post
  /// Accessible by: VENDOR (own posts), ADMIN (all posts)
  /// 🔒 REQUIRES: Ownership check or ADMIN role
  static Future<Map<String, dynamic>?> updateVenue({
    required String venueId,
    required String postOwnerId,
    String? title,
    String? description,
    String? content,
    String? location,
    double? price,
    int? capacity,
    List<String>? amenities,
    String? style,
    List<String>? imagePaths, // New images to upload
    List<String>? existingImageUrls, // Existing images to keep
  }) async {
    try {
      print('✏️ Updating venue: $venueId');

      // ✅ CHECK PERMISSION using RoleHelper
      final canEdit = await RoleHelper.canEditPost(postOwnerId);
      if (!canEdit) {
        print('❌ PERMISSION DENIED: Cannot edit this post');
        return {
          'error': 'PERMISSION_DENIED',
          'message': 'Bạn không có quyền chỉnh sửa bài đăng này.',
        };
      }

      final role = await RoleHelper.getCurrentRole();
      print('✅ Permission granted - Role: $role');

      final token = await StorageService.getToken();
      if (token == null) {
        return {
          'error': 'NO_TOKEN',
          'message': 'Vui lòng đăng nhập để thực hiện chức năng này.',
        };
      }

      // If images are being updated, use multipart request
      if (imagePaths != null && imagePaths.isNotEmpty) {
        return await _updateVenueWithImages(
          venueId: venueId,
          token: token,
          title: title,
          description: description,
          content: content,
          location: location,
          price: price,
          capacity: capacity,
          amenities: amenities,
          style: style,
          imagePaths: imagePaths,
          existingImageUrls: existingImageUrls,
        );
      }

      // Otherwise, use JSON request (original behavior)
      final requestBody = <String, dynamic>{};

      if (title != null) requestBody['title'] = title;
      if (description != null) requestBody['description'] = description;
      if (content != null) requestBody['content'] = content;
      if (location != null) requestBody['location'] = location;
      if (price != null) requestBody['price'] = price;
      if (capacity != null) requestBody['capacity'] = capacity;
      if (amenities != null) requestBody['amenities'] = amenities;
      if (style != null) requestBody['style'] = style;

      final response = await http.put(
        Uri.parse('$baseUrl/posts/$venueId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          print('✅ Venue updated successfully!');
          return jsonData['data'];
        }
      } else if (response.statusCode == 403) {
        return {
          'error': 'FORBIDDEN',
          'message': 'Bạn không có quyền chỉnh sửa bài đăng này.',
        };
      }

      return null;
    } catch (e) {
      print('❌ Error updating venue: $e');
      return {
        'error': 'UNEXPECTED_ERROR',
        'message': 'Đã có lỗi xảy ra: $e',
      };
    }
  }

  static Future<Map<String, dynamic>?> _updateVenueWithImages({
    required String venueId,
    required String token,
    String? title,
    String? description,
    String? content,
    String? location,
    double? price,
    int? capacity,
    List<String>? amenities,
    String? style,
    required List<String> imagePaths,
    List<String>? existingImageUrls,
  }) async {
    try {
      print('📤 Updating venue with images using multipart/form-data');

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/posts/$venueId'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Add text fields
      if (title != null) request.fields['title'] = title;
      if (description != null) request.fields['description'] = description;
      if (content != null) request.fields['content'] = content;
      if (location != null) request.fields['location'] = location;
      if (price != null) request.fields['price'] = price.toString();
      if (capacity != null) request.fields['capacity'] = capacity.toString();
      if (style != null) request.fields['style'] = style;

      if (amenities != null) {
        request.fields['amenities'] = jsonEncode(amenities);
      }

      // Add existing image URLs to keep
      if (existingImageUrls != null && existingImageUrls.isNotEmpty) {
        request.fields['existingImages'] = jsonEncode(existingImageUrls);
      }

      // Add new image files
      for (var i = 0; i < imagePaths.length; i++) {
        final file = File(imagePaths[i]);
        final mimeType = _getMimeType(imagePaths[i]);

        request.files.add(await http.MultipartFile.fromPath(
          'images', // Backend expects 'images' field
          file.path,
          contentType: MediaType.parse(mimeType),
        ));

        print('📎 Added image ${i + 1}: ${file.path}');
      }

      print('📤 Sending multipart request...');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          print('✅ Venue with images updated successfully!');
          return jsonData['data'];
        }
      } else if (response.statusCode == 403) {
        return {
          'error': 'FORBIDDEN',
          'message': 'Bạn không có quyền chỉnh sửa bài đăng này.',
        };
      }

      return {
        'error': 'UPDATE_FAILED',
        'message': 'Không thể cập nhật bài viết. Vui lòng thử lại.',
      };
    } catch (e) {
      print('❌ Error updating venue with images: $e');
      return {
        'error': 'UNEXPECTED_ERROR',
        'message': 'Đã có lỗi xảy ra: $e',
      };
    }
  }

  static String _getMimeType(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  /// ✅ Delete venue/post
  /// Accessible by: VENDOR (own posts), ADMIN (all posts)
  /// 🔒 REQUIRES: Ownership check or ADMIN role
  static Future<Map<String, dynamic>> deleteVenue(
    String venueId,
    String postOwnerId, // ✅ ADDED for permission check
  ) async {
    try {
      print('🗑️ Deleting venue: $venueId');

      // ✅ CHECK PERMISSION using RoleHelper
      final canDelete = await RoleHelper.canDeletePost(postOwnerId);
      if (!canDelete) {
        print('❌ PERMISSION DENIED: Cannot delete this post');
        return {
          'success': false,
          'error': 'PERMISSION_DENIED',
          'message': 'Bạn không có quyền xóa bài đăng này.',
        };
      }

      final role = await RoleHelper.getCurrentRole();
      print('✅ Permission granted - Role: $role');

      final token = await StorageService.getToken();
      if (token == null) {
        return {
          'success': false,
          'error': 'NO_TOKEN',
          'message': 'Vui lòng đăng nhập để thực hiện chức năng này.',
        };
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/posts/$venueId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('✅ Venue deleted successfully!');
        return {
          'success': true,
          'message': jsonData['message'] ?? 'Xóa bài đăng thành công',
        };
      } else if (response.statusCode == 403) {
        return {
          'success': false,
          'error': 'FORBIDDEN',
          'message': 'Bạn không có quyền xóa bài đăng này.',
        };
      }

      return {
        'success': false,
        'error': 'DELETE_FAILED',
        'message': 'Không thể xóa bài đăng',
      };
    } catch (e) {
      print('❌ Error deleting venue: $e');
      return {
        'success': false,
        'error': 'UNEXPECTED_ERROR',
        'message': 'Đã có lỗi xảy ra: $e',
      };
    }
  }

  /// ✅ Get my venues/posts (for VENDOR/ADMIN)
  /// Accessible by: VENDOR, ADMIN only
  /// 🔒 REQUIRES: VENDOR or ADMIN role
  static Future<Map<String, dynamic>?> getMyVenues({
    int page = 0,
    int size = 10,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
  }) async {
    try {
      print('📋 Fetching my venues...');

      // ✅ CHECK PERMISSION using RoleHelper
      final canManage = await RoleHelper.hasAnyRole([
        RoleHelper.ROLE_VENDOR,
        RoleHelper.ROLE_ADMIN,
      ]);

      if (!canManage) {
        print('❌ PERMISSION DENIED: User cannot access this resource');
        return null;
      }

      final role = await RoleHelper.getCurrentRole();
      print('✅ Permission granted - Role: $role');

      final token = await StorageService.getToken();
      if (token == null) {
        print('❌ No token found');
        return null;
      }

      final url =
          '$baseUrl/posts/my-posts?page=$page&size=$size&sortBy=$sortBy&sortDir=$sortDir';
      print('📍 URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];

          return {
            'venues': data['content'] ?? [],
            'totalElements': data['totalElements'] ?? 0,
            'totalPages': data['totalPages'] ?? 0,
            'currentPage': data['number'] ?? page,
            'size': data['size'] ?? size,
            'hasNext': !(data['last'] ?? true),
            'hasPrevious': data['first'] == false,
          };
        }
      }

      return null;
    } catch (e) {
      print('Error fetching my venues: $e');
      return null;
    }
  }

  // =====================================================
  // 📊 STATISTICS (VENDOR/ADMIN)
  // =====================================================

  /// ✅ Get vendor statistics
  /// Accessible by: VENDOR (own stats), ADMIN (all stats)
  /// 🔒 REQUIRES: VENDOR or ADMIN role
  static Future<Map<String, dynamic>?> getVendorStatistics() async {
    try {
      print('📊 Fetching vendor statistics...');

      // ✅ CHECK PERMISSION
      final canView = await RoleHelper.hasAnyRole([
        RoleHelper.ROLE_VENDOR,
        RoleHelper.ROLE_ADMIN,
      ]);

      if (!canView) {
        print('❌ PERMISSION DENIED');
        return null;
      }

      final token = await StorageService.getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/posts/my-posts/statistics'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          return jsonData['data'];
        }
      }

      return null;
    } catch (e) {
      print('Error fetching statistics: $e');
      return null;
    }
  }
}
