import 'dart:convert';
import 'package:http/http.dart' as http;
import '../request/booking_request.dart';
import '../response/booking_response.dart';
import '../response/booking_statistics.dart';
import '../response/slot_availability_response.dart';
import 'package:booking_app/service/api_constants.dart';
import 'package:booking_app/service/storage_service.dart';

/// BookingApiService - Matches Java Spring Boot BookingController endpoints
/// Provides all booking operations for users, vendors, and admins
class BookingApiService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<String?> _getToken() async {
    try {
      return await StorageService.getToken();
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found. Please login again.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ==================== USER ENDPOINTS ====================

  /// GET /api/bookings/user/my-bookings
  /// Get current user's bookings (for USER role)
  Future<List<BookingResponse>> getMyBookings({
    int page = 0,
    int size = 10,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/bookings/user/my-bookings').replace(
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
          'sortBy': sortBy,
          'sortDir': sortDir,
        },
      );

      final response = await http.get(
        uri,
        headers: await _getHeaders(),
      );

      print('Get my bookings response: ${response.statusCode}');
      print('Request URL: $uri');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(decodedBody);

        print('Raw response structure: ${jsonData.keys}');

        // Handle ApiResponse<Page<BookingResponse>> format
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];

          // Check if data is paginated (has 'content' field)
          if (data is Map && data.containsKey('content')) {
            final List<dynamic> content = data['content'] as List<dynamic>;
            print(
                '✅ Loaded ${content.length} bookings from paginated response');
            return content
                .map((json) => BookingResponse.fromJson(json))
                .toList();
          }
          // Check if data is direct list
          else if (data is List) {
            print('✅ Loaded ${data.length} bookings from direct list');
            return data.map((json) => BookingResponse.fromJson(json)).toList();
          }
          // Check if data is single page object
          else if (data is Map) {
            print('⚠️ Unexpected Map format, trying to extract content');
            return [];
          }
        }

        // Fallback: try direct list parsing
        if (jsonData is List) {
          print('✅ Loaded ${jsonData.length} bookings (direct list)');
          return jsonData
              .map((json) => BookingResponse.fromJson(json))
              .toList();
        }

        print('No bookings found');
        return [];
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        print('❌ Error response: $errorBody');
        throw Exception('Failed to load bookings: $errorBody');
      }
    } catch (e) {
      print('Error loading my bookings: $e');
      throw Exception('Error loading bookings: $e');
    }
  }

  // Create new booking
  Future<BookingResponse> createBooking(BookingRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/bookings'),
        headers: await _getHeaders(),
        body: jsonEncode(request.toJson()),
      );

      print('Create booking response: ${response.statusCode}');
      print('Request body: ${jsonEncode(request.toJson())}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        print('✅ Response body: $decodedBody');
        final jsonData = jsonDecode(decodedBody);

        // Parse ApiResponse format: { "success": true, "data": {...}, "message": "..." }
        if (jsonData is Map && jsonData.containsKey('data')) {
          print('✅ Booking created successfully');
          print('📦 Booking data: ${jsonData['data']}');
          return BookingResponse.fromJson(jsonData['data']);
        }

        // Fallback: direct object
        return BookingResponse.fromJson(jsonData);
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        print('❌ Error creating booking: $errorBody');
        throw Exception('Failed to create booking: $errorBody');
      }
    } catch (e) {
      print('Error creating booking: $e');
      throw Exception('Error creating booking: $e');
    }
  }

  // Get all bookings for vendor
  Future<List<BookingResponse>> getAllBookingsForVendor() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/bookings/vendor'),
        headers: await _getHeaders(),
      );

      print('Get bookings response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(decodedBody);

        // Handle ApiResponse<Page<BookingResponse>> format
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];

          // Check if data is paginated (has 'content' field)
          if (data is Map && data.containsKey('content')) {
            final List<dynamic> content = data['content'] as List<dynamic>;
            print(
                '✅ Loaded ${content.length} vendor bookings from paginated response');
            return content
                .map((json) => BookingResponse.fromJson(json))
                .toList();
          }
          // Check if data is direct list
          else if (data is List) {
            print('✅ Loaded ${data.length} vendor bookings from direct list');
            return data.map((json) => BookingResponse.fromJson(json)).toList();
          }
        }

        print('No vendor bookings found');
        return [];
      } else {
        throw Exception('Failed to load bookings: ${response.body}');
      }
    } catch (e) {
      print('Error loading bookings: $e');
      throw Exception('Error loading bookings: $e');
    }
  }

  // Get booking by ID
  Future<BookingResponse> getBookingById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/bookings/vendor/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return BookingResponse.fromJson(responseData['data']);
      } else {
        throw Exception('Failed to load booking: ${response.body}');
      }
    } catch (e) {
      print('Error loading booking: $e');
      throw Exception('Error loading booking: $e');
    }
  }

  /// GET /api/bookings/vendor/{vendorId}/status/{status}
  /// Get bookings by status for vendor
  Future<List<BookingResponse>> getBookingsByStatus(
    int vendorId,
    String status, {
    int page = 0,
    int size = 10,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
  }) async {
    try {
      final uri =
          Uri.parse('$baseUrl/api/bookings/vendor/$vendorId/status/$status')
              .replace(
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
          'sortBy': sortBy,
          'sortDir': sortDir,
        },
      );

      final response = await http.get(
        uri,
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(decodedBody);

        // Handle ApiResponse<Page<BookingResponse>> format
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];

          // Check if data is paginated (has 'content' field)
          if (data is Map && data.containsKey('content')) {
            final List<dynamic> content = data['content'] as List<dynamic>;
            print(
                '✅ Loaded ${content.length} bookings by status from paginated response');
            return content
                .map((json) => BookingResponse.fromJson(json))
                .toList();
          }
          // Check if data is direct list
          else if (data is List) {
            print(
                '✅ Loaded ${data.length} bookings by status from direct list');
            return data.map((json) => BookingResponse.fromJson(json)).toList();
          }
        }

        print('No bookings found for status: $status');
        return [];
      } else {
        throw Exception('Failed to load bookings: ${response.body}');
      }
    } catch (e) {
      print('Error loading bookings by status: $e');
      throw Exception('Error loading bookings: $e');
    }
  }

  // Confirm booking
  Future<BookingResponse> confirmBooking(int id, {String? note}) async {
    try {
      print('🔄 Confirming booking ID: $id');
      final response = await http.post(
        Uri.parse('$baseUrl/api/bookings/$id/confirm'),
        headers: await _getHeaders(),
        body: note != null ? jsonEncode({'note': note}) : null,
      );

      print('📥 Confirm booking response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedBody = utf8.decode(response.bodyBytes);
        print('═══════════════════════════════════════');
        print('✅ CONFIRM BOOKING RESPONSE');
        print('Status: ${response.statusCode}');
        print('Body: $decodedBody');
        print('═══════════════════════════════════════');

        final jsonData = jsonDecode(decodedBody);

        // Check if response has nested structure with booking and slotAvailability
        if (jsonData is Map &&
            jsonData.containsKey('success') &&
            jsonData['success'] == true) {
          final data = jsonData['data'];
          print('📋 Data keys: ${data?.keys}');

          // If data has 'booking' nested object
          if (data is Map && data.containsKey('booking')) {
            print('📋 Using nested booking object');
            return BookingResponse.fromJson(data['booking']);
          }

          // Otherwise use data directly
          return BookingResponse.fromJson(data);
        }

        // Handle direct BookingResponse
        return BookingResponse.fromJson(jsonData);
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        print('❌ Failed to confirm booking: ${response.statusCode}');
        print('   Error: $errorBody');
        throw Exception('Failed to confirm booking: $errorBody');
      }
    } catch (e) {
      print('❌ Error confirming booking: $e');
      throw Exception('Error confirming booking: $e');
    }
  }

  // Reject booking
  Future<BookingResponse> rejectBooking(int id, String reason) async {
    try {
      print('🔄 Rejecting booking ID: $id with reason: $reason');

      // Backend expects reason as query parameter
      final uri = Uri.parse('$baseUrl/api/bookings/$id/reject')
          .replace(queryParameters: {'reason': reason});

      final response = await http.post(
        uri,
        headers: await _getHeaders(),
      );

      print('📥 Reject booking response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(decodedBody);

        // Parse ApiResponse format
        if (jsonData is Map && jsonData.containsKey('data')) {
          return BookingResponse.fromJson(jsonData['data']);
        }

        return BookingResponse.fromJson(jsonData);
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        throw Exception('Failed to reject booking: $errorBody');
      }
    } catch (e) {
      print('Error rejecting booking: $e');
      throw Exception('Error rejecting booking: $e');
    }
  }

  // Complete booking
  Future<BookingResponse> completeBooking(int id) async {
    try {
      print('🔄 Completing booking ID: $id');
      final response = await http.post(
        Uri.parse('$baseUrl/api/bookings/$id/complete'),
        headers: await _getHeaders(),
      );

      print('📥 Complete booking response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedBody = utf8.decode(response.bodyBytes);
        print('✅ Response body: $decodedBody');
        final jsonData = jsonDecode(decodedBody);

        // Parse ApiResponse format
        if (jsonData is Map && jsonData.containsKey('data')) {
          return BookingResponse.fromJson(jsonData['data']);
        }
        return BookingResponse.fromJson(jsonData);
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        print('❌ Failed to complete booking: $errorBody');
        throw Exception('Failed to complete booking: $errorBody');
      }
    } catch (e) {
      print('❌ Error completing booking: $e');
      throw Exception('Error completing booking: $e');
    }
  }

  // Cancel booking (by user)
  Future<BookingResponse> cancelBooking(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/bookings/$id/cancel'),
        headers: await _getHeaders(),
      );

      print('Cancel booking response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(decodedBody);

        // Parse ApiResponse format
        if (jsonData is Map && jsonData.containsKey('data')) {
          return BookingResponse.fromJson(jsonData['data']);
        }

        return BookingResponse.fromJson(jsonData);
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        throw Exception('Failed to cancel booking: $errorBody');
      }
    } catch (e) {
      print('Error cancelling booking: $e');
      throw Exception('Error cancelling booking: $e');
    }
  }

  // Delete booking
  Future<void> deleteBooking(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/bookings/vendor/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete booking: ${response.body}');
      }
    } catch (e) {
      print('Error deleting booking: $e');
      throw Exception('Error deleting booking: $e');
    }
  }

  // Search bookings
  Future<List<BookingResponse>> searchBookings(String keyword) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/bookings/vendor/search?keyword=$keyword'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        return data.map((json) => BookingResponse.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search bookings: ${response.body}');
      }
    } catch (e) {
      print('Error searching bookings: $e');
      throw Exception('Error searching bookings: $e');
    }
  }

  // Get statistics
  Future<BookingStatistics> getStatistics() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/bookings/vendor/statistics'),
        headers: await _getHeaders(),
      );

      print('Get statistics response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return BookingStatistics.fromJson(responseData['data']);
      } else {
        throw Exception('Failed to load statistics: ${response.body}');
      }
    } catch (e) {
      print('Error loading statistics: $e');
      throw Exception('Error loading statistics: $e');
    }
  }

  // Get today's bookings
  Future<List<BookingResponse>> getTodayBookings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/bookings/vendor/today'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        return data.map((json) => BookingResponse.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load today bookings: ${response.body}');
      }
    } catch (e) {
      print('Error loading today bookings: $e');
      throw Exception('Error loading today bookings: $e');
    }
  }

  // Get overdue bookings
  Future<List<BookingResponse>> getOverdueBookings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/bookings/vendor/overdue'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        return data.map((json) => BookingResponse.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load overdue bookings: ${response.body}');
      }
    } catch (e) {
      print('Error loading overdue bookings: $e');
      throw Exception('Error loading overdue bookings: $e');
    }
  }

  // ==================== AVAILABILITY ENDPOINTS ====================

  /// GET /api/bookings/availability?postId={postId}&date={date}
  /// Check basic availability for a venue on a specific date
  Future<bool> checkAvailability(int postId, DateTime date) async {
    try {
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final uri = Uri.parse('$baseUrl/api/bookings/availability').replace(
        queryParameters: {
          'postId': postId.toString(),
          'date': dateStr,
        },
      );

      final response = await http.get(
        uri,
        headers: await _getHeaders(),
      );

      print('🔍 Check availability response: ${response.statusCode}');
      print('🔍 Request URL: $uri');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        print('✅ Availability response body: $decodedBody');
        final jsonData = jsonDecode(decodedBody);

        // Handle ApiResponse format
        if (jsonData is Map && jsonData['success'] == true) {
          final isAvailable = jsonData['data'] as bool? ?? false;
          print('✅ Venue available: $isAvailable');
          return isAvailable;
        }

        // Handle direct boolean
        if (jsonData is bool) {
          print('✅ Venue available: $jsonData');
          return jsonData;
        }

        print('⚠️ Unexpected response format, returning false');
        return false;
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        print('❌ Error response: $errorBody');
        throw Exception('Failed to check availability: $errorBody');
      }
    } catch (e) {
      print('Error checking availability: $e');
      return false;
    }
  }

  /// GET /api/bookings/slot-availability?postId={postId}&date={date}
  /// Get detailed slot availability information for a venue
  Future<SlotAvailabilityResponse> getSlotAvailability(
      int postId, DateTime date) async {
    try {
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final uri = Uri.parse('$baseUrl/api/bookings/slot-availability').replace(
        queryParameters: {
          'postId': postId.toString(),
          'date': dateStr,
        },
      );

      final response = await http.get(
        uri,
        headers: await _getHeaders(),
      );

      print('🔍 Get slot availability response: ${response.statusCode}');
      print('🔍 Request URL: $uri');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        print('═══════════════════════════════════════');
        print('✅ SLOT AVAILABILITY RESPONSE');
        print('Raw body: $decodedBody');
        print('═══════════════════════════════════════');

        final jsonData = jsonDecode(decodedBody);

        // Handle ApiResponse format with nested slotAvailability
        if (jsonData is Map && jsonData['success'] == true) {
          final data = jsonData['data'];
          print('📋 Data object: $data');

          // Check if response has slotAvailability nested object
          if (data is Map && data.containsKey('slotAvailability')) {
            print('📋 Using nested slotAvailability object');
            final slotData = data['slotAvailability'];
            print('📋 Slots array length: ${slotData['slots']?.length ?? 0}');
            return SlotAvailabilityResponse.fromJson(slotData);
          }

          // Otherwise use data directly
          print('📋 Using data object directly');
          print('📋 Slots array: ${data['slots']}');
          return SlotAvailabilityResponse.fromJson(data);
        }

        // Handle direct object
        print('📋 Direct object: $jsonData');
        print('📋 Slots array: ${jsonData['slots']}');
        return SlotAvailabilityResponse.fromJson(jsonData);
      } else {
        final errorBody = utf8.decode(response.bodyBytes);
        print('❌ Error response: $errorBody');
        throw Exception('Failed to get slot availability: $errorBody');
      }
    } catch (e) {
      print('Error getting slot availability: $e');
      rethrow;
    }
  }

  // ==================== VENDOR ENDPOINTS ====================

  /// GET /api/bookings/vendor?vendorId={vendorId}&page={page}&size={size}
  /// Get authenticated vendor bookings (or admin override)
  Future<List<BookingResponse>> getVendorBookings({
    int? vendorId,
    int page = 0,
    int size = 10,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'size': size.toString(),
        'sortBy': sortBy,
        'sortDir': sortDir,
      };

      if (vendorId != null) {
        queryParams['vendorId'] = vendorId.toString();
      }

      final uri = Uri.parse('$baseUrl/api/bookings/vendor').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(
        uri,
        headers: await _getHeaders(),
      );

      print('Get vendor bookings response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(decodedBody);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];

          if (data is Map && data.containsKey('content')) {
            final List<dynamic> content = data['content'] as List<dynamic>;
            print('✅ Loaded ${content.length} vendor bookings');
            return content
                .map((json) => BookingResponse.fromJson(json))
                .toList();
          } else if (data is List) {
            print('✅ Loaded ${data.length} vendor bookings');
            return data.map((json) => BookingResponse.fromJson(json)).toList();
          }
        }

        return [];
      } else {
        throw Exception('Failed to load vendor bookings: ${response.body}');
      }
    } catch (e) {
      print('Error loading vendor bookings: $e');
      throw Exception('Error loading vendor bookings: $e');
    }
  }

  /// GET /api/bookings/venue/{venueId}
  /// Get bookings for a specific venue
  Future<List<BookingResponse>> getVenueBookings(
    int venueId, {
    int page = 0,
    int size = 10,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/bookings/venue/$venueId').replace(
        queryParameters: {
          'page': page.toString(),
          'size': size.toString(),
          'sortBy': sortBy,
          'sortDir': sortDir,
        },
      );

      final response = await http.get(
        uri,
        headers: await _getHeaders(),
      );

      print('Get venue bookings response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(decodedBody);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'];

          if (data is Map && data.containsKey('content')) {
            final List<dynamic> content = data['content'] as List<dynamic>;
            print('✅ Loaded ${content.length} venue bookings');
            return content
                .map((json) => BookingResponse.fromJson(json))
                .toList();
          } else if (data is List) {
            print('✅ Loaded ${data.length} venue bookings');
            return data.map((json) => BookingResponse.fromJson(json)).toList();
          }
        }

        return [];
      } else {
        throw Exception('Failed to load venue bookings: ${response.body}');
      }
    } catch (e) {
      print('Error loading venue bookings: $e');
      throw Exception('Error loading venue bookings: $e');
    }
  }
}
