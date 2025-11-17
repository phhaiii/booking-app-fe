import 'package:booking_app/request/booking_request.dart';
import 'package:booking_app/service/menu_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:booking_app/response/booking_response.dart';
import 'package:booking_app/response/venuedetail_response.dart';
import 'package:booking_app/service/booking_api_service.dart';
import 'package:booking_app/service/venue_service.dart';
import 'package:booking_app/service/storage_service.dart';
import 'package:booking_app/model/menu_model.dart';
import 'package:booking_app/model/time_slot_model.dart';

class UserBookingController extends GetxController {
  final BookingApiService _bookingService = BookingApiService();

  // ✅ KEEP: VenueDetailResponse cho booking details
  final RxList<BookingRequestUI> myBookings = <BookingRequestUI>[].obs;
  final RxList<VenueDetailResponse> venues = <VenueDetailResponse>[].obs;
  final RxList<MenuModel> menus = <MenuModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMenus = false.obs;

  // Booking form data
  final Rx<VenueDetailResponse?> selectedVenue = Rx<VenueDetailResponse?>(null);
  final Rx<MenuModel?> selectedMenu = Rx<MenuModel?>(null);
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxInt guestCount = 0.obs;
  final RxString specialRequests = ''.obs;
  final RxInt bookingDurationHours = 2.obs; // ✅ NEW: Default 2 hours duration
  final Rx<TimeSlot?> selectedTimeSlot = Rx<TimeSlot?>(null);
  final RxList<TimeSlot> availableTimeSlots = <TimeSlot>[].obs;

  // ✅ Định nghĩa các khung giờ cố định
  static final List<TimeSlot> defaultTimeSlots = [
    TimeSlot(startHour: 10, endHour: 12, label: '10:00 - 12:00', index: 0),
    TimeSlot(startHour: 12, endHour: 14, label: '12:00 - 14:00', index: 1),
    TimeSlot(startHour: 14, endHour: 16, label: '14:00 - 16:00', index: 2),
    TimeSlot(startHour: 16, endHour: 18, label: '16:00 - 18:00', index: 3),
  ];

  // User info
  final RxString userName = 'User'.obs;
  final RxString userPhone = ''.obs;
  final RxString userEmail = ''.obs;

  // Computed properties
  List<BookingRequestUI> get pendingBookings =>
      myBookings.where((b) => b.isPending).toList();

  List<BookingRequestUI> get confirmedBookings =>
      myBookings.where((b) => b.isConfirmed).toList();

  List<BookingRequestUI> get rejectedBookings =>
      myBookings.where((b) => b.isRejected).toList();

  List<BookingRequestUI> get cancelledBookings =>
      myBookings.where((b) => b.isCancelled).toList();

  List<BookingRequestUI> get completedBookings =>
      myBookings.where((b) => b.isCompleted).toList();

  @override
  void onInit() {
    super.onInit();
    print('UserBookingController initialized');
  }

  @override
  void onReady() {
    super.onReady();
    _loadUserInfo();
    refreshData();
  }

  Future<void> refreshData() async {
    try {
      isLoading.value = true;
      print('Refreshing user bookings and venues...');

      await Future.wait([
        loadMyBookings(),
        loadVenues(),
      ]);

      print('Refresh completed');
      print('Total bookings: ${myBookings.length}');
      print('Pending: ${pendingBookings.length}');
      print('Confirmed: ${confirmedBookings.length}');
    } catch (e) {
      print('❌ Error refreshing: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tải dữ liệu: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadUserInfo() async {
    try {
      final email = await StorageService.getEmail();
      final userId = await StorageService.getUserId();

      if (email != null) {
        userEmail.value = email;
        userName.value = email.split('@')[0];
      }

      if (userId != null) {
        userPhone.value = '0123456789';
      }

      print(
          '👤 User info loaded: ${userName.value}, ${userPhone.value}, ${userEmail.value}');
    } catch (e) {
      print('❌ Error loading user info: $e');
    }
  }

  Future<void> loadMyBookings() async {
    try {
      print('Loading my bookings...');

      final response = await _bookingService.getMyBookings();

      myBookings.clear();
      myBookings.addAll(response.map((e) => e.toBookingRequestUI()).toList());

      print('✅ Loaded ${myBookings.length} user bookings');
    } catch (e) {
      print('❌ Error loading bookings: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tải lịch hẹn: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  // ✅ CHANGE: Parse response to VenueDetailResponse
  Future<void> loadVenues() async {
    try {
      print('Loading venues...');

      final response = await VenueService.getAllVenues(
        page: 0,
        size: 50,
        sortBy: 'createdAt',
        sortDir: 'desc',
      );

      if (response != null && response['venues'] != null) {
        venues.clear();

        // ✅ Parse JSON to VenueDetailResponse
        final List<VenueDetailResponse> venueList = (response['venues'] as List)
            .map((json) => VenueDetailResponse.fromJson(json))
            .toList();

        venues.addAll(venueList);
        print('✅ Loaded ${venues.length} venues');
      } else {
        print('⚠️ No venues found');
        venues.clear();
      }
    } catch (e) {
      print('❌ Error loading venues: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tải địa điểm: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  // ✅ SỬA phần loadMenusForVenue()
  Future<void> loadMenusForVenue(int venueId) async {
    try {
      isLoadingMenus.value = true;
      print('Loading menus for venue: $venueId');

      final loadedMenus = await MenuService.getMenusByPost(venueId);
      menus.value = loadedMenus;

      print('✅ Loaded ${loadedMenus.length} menus');
    } catch (e) {
      print('❌ Error loading menus: $e');
      menus.value = [];
    } finally {
      isLoadingMenus.value = false;
    }
  }

  void selectVenue(VenueDetailResponse venue) {
    selectedVenue.value = venue;
    selectedMenu.value = null;
    menus.clear();
    loadMenusForVenue(venue.id);
    print('Selected venue: ${venue.title}');
  }

  void selectMenu(MenuModel? menu) {
    selectedMenu.value = menu;
    if (menu != null) {
      print('Selected menu: ${menu.name}');
    } else {
      print('❌ No menu selected');
    }
  }

  void updateGuestCount(int count) {
    if (count < 0) count = 0;
    guestCount.value = count;
    print('Guest count: $count');
  }

  void updateSelectedDate(DateTime date) {
    // ✅ Double-check: Đảm bảo không set thời gian trong quá khứ
    if (date.isBefore(DateTime.now())) {
      print('⚠️ Attempted to set date in the past: $date');
      selectedDate.value = DateTime.now().add(const Duration(hours: 1));
      return;
    }
    selectedDate.value = date;
    print('✅ Selected date updated: $date');
    // Load available time slots khi đổi ngày
    loadAvailableTimeSlots();
  }

  void selectTimeSlot(TimeSlot? slot) {
    selectedTimeSlot.value = slot;
    if (slot != null) {
      // Cập nhật selectedDate với time từ slot
      final newDate = DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        slot.startHour,
        0,
      );
      selectedDate.value = newDate;
      print('✅ Time slot selected: ${slot.label}');
    }
  }

  Future<void> loadAvailableTimeSlots() async {
    try {
      if (selectedVenue.value == null) return;

      // Reset available slots
      availableTimeSlots.clear();
      availableTimeSlots.addAll(defaultTimeSlots);

      // TODO: Gọi API để check từng slot
      // Tạm thời hiển thị tất cả slots
      print('✅ Loaded ${availableTimeSlots.length} time slots');
    } catch (e) {
      print('❌ Error loading time slots: $e');
    }
  }

  Future<bool> checkAvailability() async {
    try {
      if (selectedVenue.value == null) {
        print('❌ No venue selected');
        return false;
      }

      // ✅ Validate thời gian trước khi gọi API
      if (selectedDate.value.isBefore(DateTime.now())) {
        print('❌ Selected date is in the past: ${selectedDate.value}');
        Get.snackbar(
          'Lỗi',
          'Thời gian đã chọn không hợp lệ. Vui lòng chọn lại.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
        return false;
      }

      print('Checking availability for ${selectedDate.value}...');

      final venueId = selectedVenue.value!.id;

      final result = await _bookingService.checkAvailability(
        venueId,
        selectedDate.value,
      );

      print('🔍 Availability result: $result');
      return result;
    } catch (e) {
      print('❌ Error checking availability: $e');
      return false;
    }
  }

  Future<void> createBooking() async {
    try {
      if (selectedVenue.value == null) {
        Get.snackbar(
          'Lỗi',
          'Vui lòng chọn địa điểm',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.1),
          colorText: Colors.orange,
        );
        return;
      }

      if (selectedTimeSlot.value == null) {
        Get.snackbar(
          'Lỗi',
          'Vui lòng chọn khung giờ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.1),
          colorText: Colors.orange,
        );
        return;
      }

      print('🔍 DEBUG: selectedTimeSlot = ${selectedTimeSlot.value}');
      print('🔍 DEBUG: slot index = ${selectedTimeSlot.value!.index}');
      print('🔍 DEBUG: slot label = ${selectedTimeSlot.value!.label}');

      if (guestCount.value == 0) {
        Get.snackbar(
          'Lỗi',
          'Vui lòng nhập số lượng khách',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.1),
          colorText: Colors.orange,
        );
        return;
      }

      if (userName.value.isEmpty ||
          userPhone.value.isEmpty ||
          userEmail.value.isEmpty) {
        Get.snackbar(
          'Lỗi',
          'Vui lòng đăng nhập lại để cập nhật thông tin',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
        return;
      }

      final isAvailable = await checkAvailability();
      print('🔍 Availability check result: $isAvailable');

      if (!isAvailable) {
        Get.snackbar(
          'Thông báo',
          'Thời gian này đã có người đặt. Vui lòng chọn thời gian khác',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.1),
          colorText: Colors.orange,
          duration: const Duration(seconds: 4),
        );
        return;
      }

      isLoading.value = true;
      print('Creating booking...');

      final venueId = selectedVenue.value!.id;
      final venue = selectedVenue.value!;

      // ✅ Calculate unit price based on menu selection or venue price
      double unitPrice;
      if (selectedMenu.value != null) {
        unitPrice = selectedMenu.value!.pricePerPerson;
      } else {
        // Use venue price divided by capacity as unit price
        unitPrice = venue.price / venue.capacity;
      }

      // ✅ Calculate start and end times
      final startTime = selectedDate.value;
      final endTime =
          selectedDate.value.add(Duration(hours: bookingDurationHours.value));

      // ✅ Get slot index from selected time slot (guaranteed non-null after validation)
      final slotIndex = selectedTimeSlot.value!.index;
      print('📍 Using slot index: $slotIndex for time slot: ${selectedTimeSlot.value!.label}');

      // ✅ Validate all required fields before creating booking
      print('🔍 Validation:');
      print('  - venueId: $venueId (${venueId.runtimeType})');
      print('  - guestCount: ${guestCount.value} (${guestCount.value.runtimeType})');
      print('  - slotIndex: $slotIndex (${slotIndex.runtimeType})');
      print('  - unitPrice: $unitPrice (${unitPrice.runtimeType})');
      print('  - postId: $venueId (${venueId.runtimeType})');

      final bookingRequest = BookingRequest(
        venueId: venueId,
        bookingDate: selectedDate.value,
        guestCount: guestCount.value,
        customerName: userName.value,
        customerPhone: userPhone.value,
        note: specialRequests.value.isEmpty ? null : specialRequests.value,
        menuId: selectedMenu.value?.id,
        postId: venueId, // ✅ NEW: postId is same as venueId
        unitPrice: unitPrice, // ✅ NEW: unit price
        startTime: startTime, // ✅ NEW: start time
        endTime: endTime, // ✅ NEW: end time
        slotIndex: slotIndex, // ✅ CRITICAL: Backend requires this
      );

      print('📤 Booking request: ${bookingRequest.toJson()}');
      await _bookingService.createBooking(bookingRequest);

      Get.snackbar(
        '✅ Thành công',
        'Đã gửi yêu cầu đặt lịch',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        duration: const Duration(seconds: 3),
      );

      _resetForm();
      await refreshData();
      Get.back();
    } catch (e) {
      print('❌ Error creating booking: $e');
      Get.snackbar(
        '❌ Lỗi',
        'Không thể đặt lịch: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelBooking(BookingRequestUI booking) async {
    try {
      isLoading.value = true;
      print('Cancelling booking ${booking.id}...');

      await _bookingService.cancelBooking(int.parse(booking.id));

      final index = myBookings.indexWhere((b) => b.id == booking.id);
      if (index != -1) {
        myBookings[index].status = BookingStatus.cancelled;
        myBookings.refresh();
      }

      Get.snackbar(
        '✅ Thành công',
        'Đã hủy đặt lịch',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );

      await loadMyBookings();
    } catch (e) {
      print('❌ Error cancelling booking: $e');
      Get.snackbar(
        '❌ Lỗi',
        'Không thể hủy: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _resetForm() {
    selectedVenue.value = null;
    selectedMenu.value = null;
    guestCount.value = 0;
    specialRequests.value = '';
    selectedDate.value = DateTime.now();
    bookingDurationHours.value = 2; // ✅ Reset duration to default
    selectedTimeSlot.value = null;
    availableTimeSlots.clear();
    menus.clear();
    print('Form reset');
  }

  // Calendar helper methods
  List<BookingRequestUI> getBookingsForDate(DateTime date) {
    return myBookings.where((booking) {
      final bookingDate = booking.requestedDate;
      return bookingDate.year == date.year &&
          bookingDate.month == date.month &&
          bookingDate.day == date.day;
    }).toList();
  }

  bool hasBookingsOnDate(DateTime date) {
    return getBookingsForDate(date).isNotEmpty;
  }

  int getBookingCountForDate(DateTime date) {
    return getBookingsForDate(date).length;
  }
}
