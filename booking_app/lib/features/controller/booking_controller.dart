import 'package:get/get.dart';
import 'package:booking_app/models/booking_statistics.dart';
import 'package:booking_app/models/booking_response.dart';
import 'package:booking_app/service/booking_api_service.dart';

class BookingController extends GetxController {
  final BookingApiService _apiService = BookingApiService();

  // Observable lists
  final RxList<BookingRequestUI> allBookings = <BookingRequestUI>[].obs;
  final RxList<BookingRequestUI> pendingBookings = <BookingRequestUI>[].obs;
  final RxList<BookingRequestUI> confirmedBookings = <BookingRequestUI>[].obs;
  final RxList<BookingRequestUI> rejectedBookings = <BookingRequestUI>[].obs;
  final RxList<BookingRequestUI> completedBookings = <BookingRequestUI>[].obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;

  // Statistics
  final Rx<BookingStatistics?> statistics = Rx<BookingStatistics?>(null);

  // Selected date
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    loadAllBookings();
    loadStatistics();
  }

  // Load all bookings
  Future<void> loadAllBookings() async {
    try {
      isLoading.value = true;
      final bookings = await _apiService.getAllBookingsForVendor();
      allBookings.assignAll(
          bookings.map((booking) => booking.toBookingRequestUI()).toList());
      _categorizeBookings();
    } catch (e) {
      print('❌ Error loading bookings: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tải danh sách đặt lịch: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh bookings
  Future<void> refreshBookings() async {
    try {
      isRefreshing.value = true;
      final bookings = await _apiService.getAllBookingsForVendor();
      allBookings.assignAll(
          bookings.map((booking) => booking.toBookingRequestUI()).toList());
      _categorizeBookings();
      await loadStatistics();
    } catch (e) {
      print('❌ Error refreshing bookings: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể làm mới dữ liệu: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  // Categorize bookings by status
  void _categorizeBookings() {
    pendingBookings.clear();
    confirmedBookings.clear();
    rejectedBookings.clear();
    completedBookings.clear();

    for (var booking in allBookings) {
      switch (booking.status) {
        case BookingStatus.pending:
          pendingBookings.add(booking);
          break;
        case BookingStatus.confirmed:
          confirmedBookings.add(booking);
          break;
        case BookingStatus.rejected:
        case BookingStatus.cancelled:
          rejectedBookings.add(booking);
          break;
        case BookingStatus.completed:
          completedBookings.add(booking);
          break;
      }
    }
  }

  // Load statistics
  Future<void> loadStatistics() async {
    try {
      statistics.value = await _apiService.getStatistics();
    } catch (e) {
      print('❌ Error loading statistics: $e');
    }
  }

  // Confirm booking
  Future<void> confirmBooking(BookingRequestUI booking) async {
    try {
      await _apiService.confirmBooking(int.parse(booking.id));
      await refreshBookings();

      Get.snackbar(
        '✅ Đã xác nhận',
        'Đặt lịch của ${booking.customerName} đã được xác nhận',
        backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
        colorText: Get.theme.colorScheme.primary,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        '❌ Lỗi',
        'Không thể xác nhận đặt lịch: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Reject booking
  Future<void> rejectBooking(BookingRequestUI booking, String reason) async {
    try {
      await _apiService.rejectBooking(int.parse(booking.id), reason);
      await refreshBookings();

      Get.snackbar(
        '❌ Đã từ chối',
        'Đặt lịch của ${booking.customerName} đã bị từ chối',
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        '❌ Lỗi',
        'Không thể từ chối đặt lịch: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Complete booking
  Future<void> completeBooking(BookingRequestUI booking) async {
    try {
      await _apiService.completeBooking(int.parse(booking.id));
      await refreshBookings();

      Get.snackbar(
        '✅ Đã hoàn thành',
        'Đặt lịch của ${booking.customerName} đã hoàn thành',
        backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
        colorText: Get.theme.colorScheme.primary,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        '❌ Lỗi',
        'Không thể hoàn thành đặt lịch: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Search bookings
  Future<void> searchBookings(String keyword) async {
    try {
      isLoading.value = true;
      final bookings = await _apiService.searchBookings(keyword);
      allBookings.assignAll(
          bookings.map((booking) => booking.toBookingRequestUI()).toList());
      _categorizeBookings();
    } catch (e) {
      Get.snackbar(
        '❌ Lỗi',
        'Không thể tìm kiếm: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get bookings for specific date
  List<BookingRequestUI> getBookingsForDate(DateTime date) {
    return allBookings.where((booking) {
      return booking.requestedDate.year == date.year &&
          booking.requestedDate.month == date.month &&
          booking.requestedDate.day == date.day;
    }).toList();
  }

  // Update selected date
  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
  }
}
