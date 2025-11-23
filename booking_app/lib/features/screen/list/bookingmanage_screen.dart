import 'package:booking_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/features/controller/booking_controller.dart';
import 'package:booking_app/response/booking_response.dart';
import 'package:table_calendar/table_calendar.dart';

// Import widgets từ common/booking
import 'package:booking_app/common/booking/booking_stats_card.dart';
import 'package:booking_app/common/booking/booking_calendar_widget.dart';
import 'package:booking_app/common/booking/booking_tab_bar.dart';
import 'package:booking_app/common/booking/booking_list_widget.dart';
import 'package:booking_app/common/booking/booking_loading_widget.dart';
import 'package:booking_app/common/booking/booking_timeslot_widget.dart';

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
  BookingController? controller;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int selectedTabIndex = 0;
  bool canManageBookings = true; 
  bool isInitialLoad = true; 

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();

    if (!Get.isRegistered<BookingController>()) {
      controller = Get.put(BookingController());
    } else {
      controller = Get.find<BookingController>();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller?.refreshBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: Obx(() {
        final ctrl = controller!;

        // ✅ Set isInitialLoad = false sau khi load xong (dù có data hay không)
        if (isInitialLoad && !ctrl.isLoading.value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                isInitialLoad = false;
              });
            }
          });
        }

        print(
            ' Building body: isLoading=${ctrl.isLoading.value}, allBookings=${ctrl.allBookings.length}, isInitialLoad=$isInitialLoad');

        // ✅ Chỉ hiển thị loading khi đang initial load
        if (isInitialLoad) {
          print('   → Showing loading widget');
          return const BookingLoadingWidget();
        }

        print('   → Showing main content');
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
                  tabs: const [
                    'Chờ duyệt',
                    'Đã duyệt',
                    'Đã từ chối',
                    'Đã hủy',
                    'Khung giờ',
                  ],
                ),
                const SizedBox(height: 16),
                _buildTabContent(ctrl),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      }),
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

  Widget _buildTabContent(BookingController ctrl) {
    print(
        '🔍 _buildTabContent: selectedTabIndex=$selectedTabIndex, canManageBookings=$canManageBookings');
    return Obx(() {
      switch (selectedTabIndex) {
        case 0: // Pending
          print(
              '📋 Building Pending tab: ${ctrl.pendingBookings.length} bookings, showActions=$canManageBookings');
          return BookingListWidget(
            bookings: ctrl.pendingBookings,
            emptyMessage: 'Không có yêu cầu nào đang chờ',
            emptyIcon: Iconsax.clock,
            emptyColor: Colors.orange,
            showActions: canManageBookings, // ✅ Chỉ hiển thị nút nếu có quyền
            onConfirm: canManageBookings
                ? (booking) => _confirmBooking(booking)
                : null,
            onReject:
                canManageBookings ? (booking) => _rejectBooking(booking) : null,
            onShowDetails: (booking) => _showBookingDetails(booking),
          );
        case 1: // Confirmed
          return BookingListWidget(
            bookings: ctrl.confirmedBookings,
            emptyMessage: 'Chưa có đặt lịch nào được xác nhận',
            emptyIcon: Iconsax.tick_circle,
            emptyColor: Colors.green,
            showActions: false,
            onShowDetails: (booking) => _showBookingDetails(booking),
          );
        case 2: // Rejected
          return BookingListWidget(
            bookings: ctrl.rejectedBookings,
            emptyMessage: 'Chưa có đặt lịch nào bị từ chối',
            emptyIcon: Iconsax.close_circle,
            emptyColor: Colors.red,
            showActions: false,
            onShowDetails: (booking) => _showBookingDetails(booking),
          );
        case 3: // Cancelled
          return BookingListWidget(
            bookings: ctrl.cancelledBookings,
            emptyMessage: 'Chưa có đặt lịch nào bị hủy',
            emptyIcon: Iconsax.slash,
            emptyColor: Colors.grey,
            showActions: false,
            onShowDetails: (booking) => _showBookingDetails(booking),
          );
        case 4: // Time Slots tab
          return BookingTimeSlotsWidget(
            controller: ctrl,
            selectedDate: _selectedDay ?? DateTime.now(),
          );
        default:
          return const SizedBox();
      }
    });
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

  void _confirmBooking(BookingResponse booking) {
    print('🔵 _confirmBooking called for booking ID: ${booking.id}');
    print('   Customer: ${booking.customerName}');
    print('   Status: ${booking.status}');

    BookingConfirmDialog.show(
      context,
      booking: booking,
      onConfirm: () {
        print('✅ User confirmed in dialog');
        Get.back();
        controller?.confirmBooking(booking);
      },
    );
  }

  void _rejectBooking(BookingResponse booking) {
    print('🔴 _rejectBooking called for booking ID: ${booking.id}');
    print('   Customer: ${booking.customerName}');
    print('   Status: ${booking.status}');

    BookingRejectDialog.show(
      context,
      booking: booking,
      onReject: (reason) {
        print('❌ User rejected with reason: $reason');
        Get.back();
        controller?.rejectBooking(booking, reason);
      },
    );
  }

  void _showBookingDetails(BookingResponse booking) {
    BookingDetailDialog.show(context, booking: booking);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
