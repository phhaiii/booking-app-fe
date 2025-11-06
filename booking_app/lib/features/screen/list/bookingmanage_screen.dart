import 'package:booking_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/features/controller/booking_controller.dart';
import 'package:booking_app/models/booking_response.dart';
import 'package:table_calendar/table_calendar.dart';

// Import widgets từ common/booking
import 'package:booking_app/common/booking/booking_stats_card.dart';
import 'package:booking_app/common/booking/booking_calendar_widget.dart';
import 'package:booking_app/common/booking/booking_tab_bar.dart';
import 'package:booking_app/common/booking/booking_list_widget.dart';
import 'package:booking_app/common/booking/booking_loading_widget.dart';

// Import dialogs
import 'package:booking_app/utils/dialogs/booking_confirm_dialog.dart';
import 'package:booking_app/utils/dialogs/booking_reject_dialog.dart';
import 'package:booking_app/utils/dialogs/booking_detail_dialog.dart';
import 'package:booking_app/utils/dialogs/booking_filter_dialog.dart';

class BookingManagementScreen extends StatefulWidget {
  const BookingManagementScreen({super.key});

  @override
  State<BookingManagementScreen> createState() =>
      _BookingManagementScreenState();
}

class _BookingManagementScreenState extends State<BookingManagementScreen> {
  // ✅ FIX: Không dùng late, khởi tạo trong initState
  BookingController? controller;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();

    // ✅ FIX: Khởi tạo controller đúng cách
    if (!Get.isRegistered<BookingController>()) {
      controller = Get.put(BookingController());
    } else {
      controller = Get.find<BookingController>();
    }

    // ✅ FIX: Đợi frame render xong mới load data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller?.refreshBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: Kiểm tra controller null
    if (controller == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: WColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: GetBuilder<BookingController>(
        // ✅ FIX: Dùng GetBuilder thay vì Obx
        init: controller,
        builder: (ctrl) {
          if (ctrl.isLoading.value && ctrl.allBookings.isEmpty) {
            return const BookingLoadingWidget();
          }

          return RefreshIndicator(
            onRefresh: () => ctrl.refreshBookings(),
            color: WColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  BookingStatsCards(controller: ctrl),
                  const SizedBox(height: 16),
                  BookingCalendarWidget(
                    controller: ctrl,
                    calendarFormat: _calendarFormat,
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,
                    onDaySelected: _onDaySelected,
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  BookingTabBar(
                    selectedIndex: selectedTabIndex,
                    onTabSelected: (index) {
                      setState(() {
                        selectedTabIndex = index;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTabContent(ctrl),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Quản lý đặt lịch',
        style: TextStyle(
          color: WColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () => BookingFilterDialog.show(context),
          icon: const Icon(Iconsax.filter, color: WColors.primary),
          tooltip: 'Lọc',
        ),
        IconButton(
          onPressed: () => controller?.refreshBookings(),
          icon: const Icon(Iconsax.refresh, color: WColors.primary),
          tooltip: 'Làm mới',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ✅ FIX: Thêm parameter controller
  Widget _buildTabContent(BookingController ctrl) {
    switch (selectedTabIndex) {
      case 0:
        return BookingListWidget(
          bookings: ctrl.pendingBookings,
          emptyMessage: 'Không có yêu cầu nào đang chờ',
          emptyIcon: Iconsax.clock,
          emptyColor: Colors.orange,
          showActions: true,
          onConfirm: (booking) => _confirmBooking(booking),
          onReject: (booking) => _rejectBooking(booking),
          onShowDetails: (booking) => _showBookingDetails(booking),
        );
      case 1:
        return BookingListWidget(
          bookings: ctrl.confirmedBookings,
          emptyMessage: 'Chưa có đặt lịch nào được xác nhận',
          emptyIcon: Iconsax.tick_circle,
          emptyColor: Colors.green,
          showActions: false,
          onShowDetails: (booking) => _showBookingDetails(booking),
        );
      case 2:
        return BookingListWidget(
          bookings: ctrl.rejectedBookings,
          emptyMessage: 'Chưa có đặt lịch nào bị từ chối',
          emptyIcon: Iconsax.close_circle,
          emptyColor: Colors.red,
          showActions: false,
          onShowDetails: (booking) => _showBookingDetails(booking),
        );
      default:
        return const SizedBox();
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      controller?.updateSelectedDate(selectedDay);
    }
  }

  void _confirmBooking(BookingRequestUI booking) {
    BookingConfirmDialog.show(
      context,
      booking: booking,
      onConfirm: () {
        Get.back();
        controller?.confirmBooking(booking);
      },
    );
  }

  void _rejectBooking(BookingRequestUI booking) {
    BookingRejectDialog.show(
      context,
      booking: booking,
      onReject: (reason) {
        Get.back();
        controller?.rejectBooking(booking, reason);
      },
    );
  }

  void _showBookingDetails(BookingRequestUI booking) {
    BookingDetailDialog.show(context, booking: booking);
  }

  @override
  void dispose() {
    // ✅ FIX: Không dispose controller ở đây nếu dùng Get.put
    // Controller sẽ tự dispose khi không còn được sử dụng
    super.dispose();
  }
}
