import 'package:booking_app/features/controller/userbooking_controller.dart';
import 'package:booking_app/features/screen/userbooking/create_booking_screen.dart';
import 'package:booking_app/response/booking_response.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// Import dialogs
import 'package:booking_app/utils/dialogs/booking_detail_dialog.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  late UserBookingController _controller;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _controller = Get.put(UserBookingController());

    // ✅ Delay để tránh rebuild trong initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Lịch hẹn của tôi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: WColors.primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: WColors.primary),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            onPressed: () => _controller.refreshData(),
            icon: const Icon(Iconsax.refresh, color: WColors.primary),
            tooltip: 'Làm mới',
          ),
          IconButton(
            onPressed: () => Get.to(() => const CreateBookingScreen()),
            icon: const Icon(Iconsax.add_circle, color: WColors.primary),
            tooltip: 'Tạo lịch hẹn mới',
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value && _controller.myBookings.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: WColors.primary),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _controller.refreshData(),
          color: WColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: WSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBookingSummary(),
                const SizedBox(height: WSizes.spaceBtwSections),
                _buildCalendarCard(),
                const SizedBox(height: WSizes.spaceBtwSections),
                _buildEventsSection(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBookingSummary() {
    return Obx(() {
      final totalBookings = _controller.myBookings.length;
      final pendingCount = _controller.pendingBookings.length;
      final confirmedCount = _controller.confirmedBookings.length;

      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: _buildSummaryItem(
                'Chờ duyệt',
                pendingCount,
                Iconsax.clock,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryItem(
                'Đã duyệt',
                confirmedCount,
                Iconsax.tick_circle,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryItem(
                'Tổng',
                totalBookings,
                Iconsax.calendar_1,
                WColors.primary,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryItem(
      String label, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TableCalendar<BookingRequestUI>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        eventLoader: (day) => _controller.getBookingsForDate(day),
        startingDayOfWeek: StartingDayOfWeek.monday,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
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
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: TextStyle(color: Colors.red.shade400),
          selectedDecoration: const BoxDecoration(
            color: WColors.primary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: WColors.primary.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          markersMaxCount: 3,
          markerSize: 6,
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonShowsNext: false,
          formatButtonDecoration: BoxDecoration(
            color: WColors.primary,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          formatButtonTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          formatButtonPadding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          leftChevronIcon: Icon(Icons.chevron_left, color: WColors.primary),
          rightChevronIcon: Icon(Icons.chevron_right, color: WColors.primary),
        ),
      ),
    );
  }

  Widget _buildEventsSection() {
    final selectedDate = _selectedDay ?? DateTime.now();
    final dateStr = DateFormat('dd/MM/yyyy').format(selectedDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lịch hẹn ngày $dateStr',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: WColors.primary,
            ),
          ),
          const SizedBox(height: WSizes.spaceBtwItems),
          _buildEventsList(),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    final selectedBookings =
        _controller.getBookingsForDate(_selectedDay ?? DateTime.now());

    if (selectedBookings.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(Iconsax.calendar_remove,
                size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Không có lịch hẹn',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nhấn + để thêm lịch hẹn mới',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: selectedBookings
          .map((booking) => _buildBookingCard(booking))
          .toList(),
    );
  }

  Widget _buildBookingCard(BookingRequestUI booking) {
    final statusInfo = _getStatusInfo(booking.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showBookingDetails(booking),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusInfo['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: statusInfo['color'].withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusInfo['icon'],
                            size: 14, color: statusInfo['color']),
                        const SizedBox(width: 4),
                        Text(
                          statusInfo['label'],
                          style: TextStyle(
                            color: statusInfo['color'],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    DateFormat('HH:mm').format(booking.requestedDate),
                    style: const TextStyle(
                      color: WColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: WColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Iconsax.calendar_tick,
                        color: WColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.serviceName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: WColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Iconsax.location,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                booking.venueName ?? 'Không rõ địa điểm',
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Iconsax.people,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              '${booking.numberOfGuests ?? 0} khách',
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (booking.status == BookingStatus.pending) ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showCancelDialog(booking),
                        icon: const Icon(Iconsax.close_circle, size: 18),
                        label: const Text('Hủy'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showBookingDetails(booking),
                        icon: const Icon(Iconsax.eye, size: 18),
                        label: const Text('Chi tiết'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: WColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showBookingDetails(booking),
                    icon: const Icon(Iconsax.eye, size: 18),
                    label: const Text('Xem chi tiết'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusInfo(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return {
          'color': Colors.orange,
          'icon': Iconsax.clock,
          'label': 'CHỜ DUYỆT',
        };
      case BookingStatus.confirmed:
        return {
          'color': Colors.green,
          'icon': Iconsax.tick_circle,
          'label': 'ĐÃ DUYỆT',
        };
      case BookingStatus.rejected:
        return {
          'color': Colors.red,
          'icon': Iconsax.close_circle,
          'label': 'TỪ CHỐI',
        };
      case BookingStatus.completed:
        return {
          'color': Colors.blue,
          'icon': Iconsax.medal_star,
          'label': 'HOÀN THÀNH',
        };
      case BookingStatus.cancelled:
        return {
          'color': Colors.grey,
          'icon': Iconsax.close_square,
          'label': 'ĐÃ HỦY',
        };
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  void _showCancelDialog(BookingRequestUI booking) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Xác nhận hủy',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bạn có chắc muốn hủy đặt lịch này không?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.serviceName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd/MM/yyyy - HH:mm')
                        .format(booking.requestedDate),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Không', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _controller.cancelBooking(booking);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Xác nhận hủy'),
          ),
        ],
      ),
    );
  }

  void _showBookingDetails(BookingRequestUI booking) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: WColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Iconsax.calendar_tick,
                      color: WColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Chi tiết đặt lịch',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: WColors.primary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    color: Colors.grey,
                  ),
                ],
              ),
              const Divider(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Mã đặt lịch', '#${booking.id}'),
                      _buildDetailRow('Dịch vụ', booking.serviceName),
                      _buildDetailRow(
                          'Địa điểm', booking.venueName ?? 'Không rõ'),
                      _buildDetailRow(
                        'Ngày & giờ',
                        DateFormat('dd/MM/yyyy - HH:mm')
                            .format(booking.requestedDate),
                      ),
                      _buildDetailRow(
                          'Số khách', '${booking.numberOfGuests ?? 0} người'),
                      _buildDetailRow(
                        'Trạng thái',
                        _getStatusInfo(booking.status)['label'],
                      ),
                      if (booking.message != null &&
                          booking.message!.isNotEmpty)
                        _buildDetailRow('Ghi chú', booking.message!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Đóng'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
