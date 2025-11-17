import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:booking_app/response/booking_response.dart';
import 'package:booking_app/response/booking_statistics.dart';
import 'package:booking_app/response/slot_availability_response.dart';
import 'package:booking_app/formatter/booking_setting.dart';
import 'package:booking_app/service/booking_api_service.dart';

/// BookingController - Matches Java Spring Boot BookingController structure
/// Manages all booking operations for users, vendors, and admins
class BookingController extends GetxController {
  final BookingApiService _bookingService = BookingApiService();

  // Observable lists
  final RxList<BookingRequestUI> allBookings = <BookingRequestUI>[].obs;
  final RxList<BookingRequestUI> myBookings = <BookingRequestUI>[].obs;
  final RxList<BookingRequestUI> vendorBookings = <BookingRequestUI>[].obs;

  final RxBool isLoading = false.obs;
  final Rx<BookingStatistics?> statistics = Rx<BookingStatistics?>(null);
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<SlotAvailabilityResponse?> slotAvailability =
      Rx<SlotAvailabilityResponse?>(null);

  final Rx<BookingSettings> settings = BookingSettings(
    id: 'default',
    workStartHour: 10,
    workEndHour: 20,
    consultantCapacity: 2,
    sessionDurationHours: 2,
  ).obs;

  // Computed properties - matches backend status filtering
  List<BookingRequestUI> get pendingBookings =>
      allBookings.where((b) => b.status == BookingStatus.pending).toList();

  List<BookingRequestUI> get confirmedBookings =>
      allBookings.where((b) => b.status == BookingStatus.confirmed).toList();

  List<BookingRequestUI> get rejectedBookings =>
      allBookings.where((b) => b.status == BookingStatus.rejected).toList();

  List<BookingRequestUI> get cancelledBookings =>
      allBookings.where((b) => b.status == BookingStatus.cancelled).toList();

  List<BookingRequestUI> get completedBookings =>
      allBookings.where((b) => b.status == BookingStatus.completed).toList();

  // ✅ THÊM: Get time slots cho ngày được chọn
  List<TimeSlot> getTimeSlotsForDate(DateTime date) {
    if (!settings.value.isWorkingDay(date)) {
      return [];
    }

    final slots = settings.value.timeSlots;
    final bookingsOnDate = getBookingsForDate(date);

    // Count bookings per slot
    for (var slot in slots) {
      slot.bookedCount = bookingsOnDate.where((booking) {
        final bookingHour = booking.requestedDate.hour;
        return bookingHour >= slot.startHour && bookingHour < slot.endHour;
      }).length;
    }

    return slots;
  }

  // ✅ THÊM: Check slot availability
  bool isSlotAvailable(DateTime date, int startHour) {
    final slots = getTimeSlotsForDate(date);
    final slot = slots.firstWhereOrNull(
      (s) => s.startHour == startHour,
    );
    return slot?.isAvailable ?? false;
  }

  // ✅ THÊM: Get available slots for date
  List<TimeSlot> getAvailableSlots(DateTime date) {
    return getTimeSlotsForDate(date).where((slot) => slot.isAvailable).toList();
  }

  // ✅ THÊM: Get slot occupancy for date
  Map<String, dynamic> getSlotOccupancy(DateTime date) {
    final slots = getTimeSlotsForDate(date);
    final totalCapacity = settings.value.totalCapacityPerDay;
    final bookedCount =
        slots.fold<int>(0, (sum, slot) => sum + slot.bookedCount);

    return {
      'totalCapacity': totalCapacity,
      'bookedCount': bookedCount,
      'remainingCapacity': totalCapacity - bookedCount,
      'occupancyRate': totalCapacity > 0 ? bookedCount / totalCapacity : 0.0,
      'slots': slots,
    };
  }

  @override
  void onInit() {
    super.onInit();
    print('BookingController initialized');
    print(
        'Settings: ${settings.value.workStartHour}h - ${settings.value.workEndHour}h');
    print('Capacity: ${settings.value.consultantCapacity} consultants');
    print('Session: ${settings.value.sessionDurationHours}h');
  }

  @override
  void onReady() {
    super.onReady();
    refreshBookings();
  }

  // ==================== USER ENDPOINTS ====================

  /// GET /api/bookings/user/my-bookings
  /// Get current user's bookings (for USER role)
  Future<void> getMyBookings({
    int page = 0,
    int size = 10,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
  }) async {
    try {
      isLoading.value = true;
      print('GET /api/bookings/user/my-bookings - page: $page, size: $size');

      final response = await _bookingService.getMyBookings(
        page: page,
        size: size,
        sortBy: sortBy,
        sortDir: sortDir,
      );

      myBookings.clear();
      myBookings.addAll(response.map((e) => e.toBookingRequestUI()).toList());

      print('✅ Loaded ${myBookings.length} user bookings');
    } catch (e) {
      print('❌ Error loading my bookings: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tải danh sách đặt chỗ: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// GET /api/bookings/{id}
  /// Get booking by ID (numeric only)
  Future<BookingRequestUI?> getBookingById(int id) async {
    try {
      isLoading.value = true;
      print('GET /api/bookings/$id');

      final response = await _bookingService.getBookingById(id);

      print('✅ Loaded booking $id');
      return response.toBookingRequestUI();
    } catch (e) {
      print('❌ Error loading booking $id: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tải thông tin đặt chỗ: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// GET /api/bookings/availability?postId={postId}&date={date}
  /// Check basic availability for a venue on a specific date
  Future<bool> checkAvailability(int postId, DateTime date) async {
    try {
      print('GET /api/bookings/availability - postId: $postId, date: $date');

      final isAvailable = await _bookingService.checkAvailability(postId, date);

      print('✅ Venue available: $isAvailable');
      return isAvailable;
    } catch (e) {
      print('❌ Error checking availability: $e');
      return false;
    }
  }

  /// GET /api/bookings/slot-availability?postId={postId}&date={date}
  /// Get detailed slot availability information
  Future<SlotAvailabilityResponse?> getSlotAvailability(
      int postId, DateTime date) async {
    try {
      print(
          'GET /api/bookings/slot-availability - postId: $postId, date: $date');

      final response = await _bookingService.getSlotAvailability(postId, date);
      slotAvailability.value = response;

      print(
          '✅ Loaded slot availability: ${response.availableSlots}/${response.totalSlots} available');
      return response;
    } catch (e) {
      print('❌ Error getting slot availability: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể kiểm tra tình trạng chỗ trống: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return null;
    }
  }

  /// POST /api/bookings/{id}/cancel
  /// Cancel booking (by user)
  Future<void> cancelBooking(BookingRequestUI booking) async {
    try {
      isLoading.value = true;
      print('POST /api/bookings/${booking.id}/cancel');

      await _bookingService.cancelBooking(int.parse(booking.id));

      final index = allBookings.indexWhere((b) => b.id == booking.id);
      if (index != -1) {
        allBookings[index].status = BookingStatus.cancelled;
        allBookings.refresh();
      }

      Get.snackbar(
        '✅ Thành công',
        'Đã hủy đặt chỗ',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );

      await refreshBookings();
    } catch (e) {
      print('❌ Error cancelling booking: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể hủy đặt chỗ: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== VENDOR ENDPOINTS ====================

  /// GET /api/bookings/vendor
  /// Get authenticated vendor bookings
  Future<void> getVendorBookings({
    int? vendorId,
    int page = 0,
    int size = 10,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
  }) async {
    try {
      isLoading.value = true;
      print(
          'GET /api/bookings/vendor - vendorId: $vendorId, page: $page, size: $size');

      final response = await _bookingService.getVendorBookings(
        vendorId: vendorId,
        page: page,
        size: size,
        sortBy: sortBy,
        sortDir: sortDir,
      );

      vendorBookings.clear();
      vendorBookings
          .addAll(response.map((e) => e.toBookingRequestUI()).toList());

      print('✅ Loaded ${vendorBookings.length} vendor bookings');
    } catch (e) {
      print('❌ Error loading vendor bookings: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tải danh sách đặt chỗ: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// GET /api/bookings/venue/{venueId}
  /// Get bookings for a specific venue
  Future<void> getVenueBookings(
    int venueId, {
    int page = 0,
    int size = 10,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
  }) async {
    try {
      isLoading.value = true;
      print('GET /api/bookings/venue/$venueId - page: $page, size: $size');

      final response = await _bookingService.getVenueBookings(
        venueId,
        page: page,
        size: size,
        sortBy: sortBy,
        sortDir: sortDir,
      );

      allBookings.clear();
      allBookings.addAll(response.map((e) => e.toBookingRequestUI()).toList());

      print('✅ Loaded ${allBookings.length} venue bookings');
    } catch (e) {
      print('❌ Error loading venue bookings: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tải danh sách đặt chỗ: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// GET /api/bookings/vendor/{vendorId}/status/{status}
  /// Get bookings by status for vendor
  Future<void> getBookingsByStatus(
    int vendorId,
    String status, {
    int page = 0,
    int size = 10,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
  }) async {
    try {
      isLoading.value = true;
      print(
          'GET /api/bookings/vendor/$vendorId/status/$status - page: $page, size: $size');

      final response = await _bookingService.getBookingsByStatus(
        vendorId,
        status,
        page: page,
        size: size,
        sortBy: sortBy,
        sortDir: sortDir,
      );

      allBookings.clear();
      allBookings.addAll(response.map((e) => e.toBookingRequestUI()).toList());

      print('✅ Loaded ${allBookings.length} bookings with status $status');
    } catch (e) {
      print('❌ Error loading bookings by status: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tải danh sách đặt chỗ: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// POST /api/bookings/{id}/confirm
  /// Confirm booking (Vendor/Admin only)
  Future<void> confirmBooking(BookingRequestUI booking) async {
    try {
      isLoading.value = true;
      final date = booking.requestedDate;
      final hour = date.hour;

      if (!isSlotAvailable(date, hour)) {
        Get.snackbar(
          '⚠️ Cảnh báo',
          'Khung giờ này đã đầy. Vui lòng chọn thời gian khác.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.1),
          colorText: Colors.orange,
        );
        return;
      }

      print('POST /api/bookings/${booking.id}/confirm');

      await _bookingService.confirmBooking(int.parse(booking.id));

      final index = allBookings.indexWhere((b) => b.id == booking.id);
      if (index != -1) {
        allBookings[index].status = BookingStatus.confirmed;
        allBookings[index].confirmedAt = DateTime.now();
        allBookings.refresh();
      }

      Get.snackbar(
        '✅ Thành công',
        'Đã xác nhận đặt lịch',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );

      await refreshBookings();
    } catch (e) {
      print('❌ Error confirming booking: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể xác nhận: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// POST /api/bookings/{id}/complete
  /// Complete booking (Vendor/Admin only)
  Future<void> completeBooking(BookingRequestUI booking) async {
    try {
      isLoading.value = true;
      print('POST /api/bookings/${booking.id}/complete');

      await _bookingService.completeBooking(int.parse(booking.id));

      final index = allBookings.indexWhere((b) => b.id == booking.id);
      if (index != -1) {
        allBookings[index].status = BookingStatus.completed;
        allBookings.refresh();
      }

      Get.snackbar(
        '✅ Thành công',
        'Đã hoàn thành đặt lịch',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );

      await refreshBookings();
    } catch (e) {
      print('❌ Error completing booking: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể hoàn thành: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// POST /api/bookings/{id}/reject (supports POST, PUT, GET)
  /// Reject booking (Vendor/Admin only)
  Future<void> rejectBooking(BookingRequestUI booking, String reason) async {
    try {
      isLoading.value = true;
      print('POST /api/bookings/${booking.id}/reject - reason: $reason');

      await _bookingService.rejectBooking(int.parse(booking.id), reason);

      final index = allBookings.indexWhere((b) => b.id == booking.id);
      if (index != -1) {
        allBookings[index].status = BookingStatus.rejected;
        allBookings[index].rejectedAt = DateTime.now();
        allBookings.refresh();
      }

      Get.snackbar(
        '✅ Thành công',
        'Đã từ chối đặt lịch',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );

      await refreshBookings();
    } catch (e) {
      print('❌ Error rejecting booking: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể từ chối: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// GET /api/bookings/vendor/statistics
  /// Get vendor booking statistics
  Future<void> getVendorBookingStatistics() async {
    try {
      print('GET /api/bookings/vendor/statistics');

      final stats = await _bookingService.getStatistics();
      statistics.value = stats;

      print('✅ Statistics updated: ${stats.totalBookings} total');
    } catch (e) {
      print('❌ Error loading statistics: $e');
    }
  }

  // ==================== ADMIN ENDPOINTS ====================

  /// DELETE /api/bookings/{id}
  /// Delete booking (Admin only)
  Future<void> deleteBooking(int id) async {
    try {
      isLoading.value = true;
      print('DELETE /api/bookings/$id');

      await _bookingService.deleteBooking(id);

      allBookings.removeWhere((b) => b.id == id.toString());
      allBookings.refresh();

      Get.snackbar(
        '✅ Thành công',
        'Đã xóa đặt chỗ',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      print('❌ Error deleting booking: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể xóa đặt chỗ: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== HELPER METHODS ====================

  /// Refresh all bookings and statistics
  Future<void> refreshBookings() async {
    try {
      isLoading.value = true;
      print('Refreshing bookings...');

      await Future.wait([
        _loadBookings(),
        _loadStatistics(),
      ]);

      print('Refresh completed');
      print('Total bookings: ${allBookings.length}');
      print('Pending: ${pendingBookings.length}');
      print('Confirmed: ${confirmedBookings.length}');
      print('Rejected: ${rejectedBookings.length}');
      print('Completed: ${completedBookings.length}');
    } catch (e) {
      print('❌ Error refreshing: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tải dữ liệu: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadBookings() async {
    try {
      final response = await _bookingService.getAllBookingsForVendor();
      print('Loaded ${response.length} bookings from API');

      allBookings.clear();
      allBookings.addAll(response.map((e) => e.toBookingRequestUI()).toList());

      print('Bookings updated in controller');
    } catch (e) {
      print('❌ Error loading bookings: $e');
      rethrow;
    }
  }

  Future<void> _loadStatistics() async {
    try {
      final stats = await _bookingService.getStatistics();
      statistics.value = stats;
      print('Statistics updated: ${stats.totalBookings} total');
    } catch (e) {
      print('❌ Error loading statistics: $e');
    }
  }

  /// Get bookings for a specific date
  List<BookingRequestUI> getBookingsForDate(DateTime date) {
    return allBookings.where((booking) {
      final bookingDate = booking.requestedDate;
      return bookingDate.year == date.year &&
          bookingDate.month == date.month &&
          bookingDate.day == date.day;
    }).toList();
  }

  /// Update selected date and refresh data
  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
    print('Selected date: $date');
    print('Bookings on this date: ${getBookingsForDate(date).length}');

    final occupancy = getSlotOccupancy(date);
    print(
        'Capacity: ${occupancy['bookedCount']}/${occupancy['totalCapacity']}');
    print(
        'Occupancy: ${(occupancy['occupancyRate'] * 100).toStringAsFixed(1)}%');
  }
}
