import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/booking_request.dart';
import '../models/booking_response.dart';
import '../models/booking_statistics.dart';
import 'package:booking_app/service/api_constants.dart';
import 'package:booking_app/service/storage_service.dart';

class BookingApiService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<String?> _getToken() async {
    try {
      return await StorageService.getToken();
    } catch (e) {
      print('❌ Error getting token: $e');
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

  // Create new booking
  Future<BookingResponse> createBooking(BookingRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookings'),
        headers: await _getHeaders(),
        body: jsonEncode(request.toJson()),
      );

      print('📤 Create booking response: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return BookingResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create booking: ${response.body}');
      }
    } catch (e) {
      print('❌ Error creating booking: $e');
      throw Exception('Error creating booking: $e');
    }
  }

  // Get all bookings for vendor
  Future<List<BookingResponse>> getAllBookingsForVendor() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings/vendor'),
        headers: await _getHeaders(),
      );

      print('📥 Get bookings response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => BookingResponse.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bookings: ${response.body}');
      }
    } catch (e) {
      print('❌ Error loading bookings: $e');
      throw Exception('Error loading bookings: $e');
    }
  }

  // Get booking by ID
  Future<BookingResponse> getBookingById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings/vendor/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return BookingResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load booking: ${response.body}');
      }
    } catch (e) {
      print('❌ Error loading booking: $e');
      throw Exception('Error loading booking: $e');
    }
  }

  // Get bookings by status
  Future<List<BookingResponse>> getBookingsByStatus(String status) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings/vendor/status/$status'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => BookingResponse.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bookings: ${response.body}');
      }
    } catch (e) {
      print('❌ Error loading bookings by status: $e');
      throw Exception('Error loading bookings: $e');
    }
  }

  // Confirm booking
  Future<BookingResponse> confirmBooking(int id, {String? note}) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/bookings/vendor/$id/confirm'),
        headers: await _getHeaders(),
        body: note != null ? jsonEncode({'note': note}) : null,
      );

      print('✅ Confirm booking response: ${response.statusCode}');

      if (response.statusCode == 200) {
        return BookingResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to confirm booking: ${response.body}');
      }
    } catch (e) {
      print('❌ Error confirming booking: $e');
      throw Exception('Error confirming booking: $e');
    }
  }

  // Reject booking
  Future<BookingResponse> rejectBooking(int id, String reason) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/bookings/vendor/$id/reject'),
        headers: await _getHeaders(),
        body: jsonEncode({'reason': reason}),
      );

      print('❌ Reject booking response: ${response.statusCode}');

      if (response.statusCode == 200) {
        return BookingResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to reject booking: ${response.body}');
      }
    } catch (e) {
      print('❌ Error rejecting booking: $e');
      throw Exception('Error rejecting booking: $e');
    }
  }

  // Complete booking
  Future<BookingResponse> completeBooking(int id) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/bookings/vendor/$id/complete'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return BookingResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to complete booking: ${response.body}');
      }
    } catch (e) {
      print('❌ Error completing booking: $e');
      throw Exception('Error completing booking: $e');
    }
  }

  // Cancel booking (by user)
  Future<BookingResponse> cancelBooking(int id) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/bookings/$id/cancel'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return BookingResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to cancel booking: ${response.body}');
      }
    } catch (e) {
      print('❌ Error cancelling booking: $e');
      throw Exception('Error cancelling booking: $e');
    }
  }

  // Delete booking
  Future<void> deleteBooking(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/bookings/vendor/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete booking: ${response.body}');
      }
    } catch (e) {
      print('❌ Error deleting booking: $e');
      throw Exception('Error deleting booking: $e');
    }
  }

  // Search bookings
  Future<List<BookingResponse>> searchBookings(String keyword) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings/vendor/search?keyword=$keyword'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => BookingResponse.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search bookings: ${response.body}');
      }
    } catch (e) {
      print('❌ Error searching bookings: $e');
      throw Exception('Error searching bookings: $e');
    }
  }

  // Get statistics
  Future<BookingStatistics> getStatistics() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings/vendor/statistics'),
        headers: await _getHeaders(),
      );

      print('📊 Get statistics response: ${response.statusCode}');

      if (response.statusCode == 200) {
        return BookingStatistics.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load statistics: ${response.body}');
      }
    } catch (e) {
      print('❌ Error loading statistics: $e');
      throw Exception('Error loading statistics: $e');
    }
  }

  // Get today's bookings
  Future<List<BookingResponse>> getTodayBookings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings/vendor/today'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => BookingResponse.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load today bookings: ${response.body}');
      }
    } catch (e) {
      print('❌ Error loading today bookings: $e');
      throw Exception('Error loading today bookings: $e');
    }
  }

  // Get overdue bookings
  Future<List<BookingResponse>> getOverdueBookings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings/vendor/overdue'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => BookingResponse.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load overdue bookings: ${response.body}');
      }
    } catch (e) {
      print('❌ Error loading overdue bookings: $e');
      throw Exception('Error loading overdue bookings: $e');
    }
  }

  // Check availability
  Future<bool> checkAvailability(int venueId, DateTime requestedDate) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/bookings/check-availability?venueId=$venueId&requestedDate=${requestedDate.toIso8601String()}'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['available'] ?? false;
      } else {
        throw Exception('Failed to check availability: ${response.body}');
      }
    } catch (e) {
      print('❌ Error checking availability: $e');
      throw Exception('Error checking availability: $e');
    }
  }
}
