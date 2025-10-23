import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Sample events
  final Map<DateTime, List<CalendarEvent>> _events = {
    DateTime(2024, 10, 25): [
      CalendarEvent('Hẹn xem venue', 'Trống Đồng Palace', '14:00'),
      CalendarEvent('Thử váy cưới', 'May Studio', '16:30'),
    ],
    DateTime(2024, 10, 28): [
      CalendarEvent('Tư vấn menu', 'Long Vĩ Palace', '10:00'),
    ],
    DateTime(2024, 11, 2): [
      CalendarEvent('Chụp ảnh cưới', 'Hồ Gươm', '06:00'),
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lịch hẹn',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: WColors.primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: WColors.primary),
          onPressed: () => Get.back(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: WSizes.defaultSpace),
            child: IconButton(
              onPressed: _showAddEventDialog,
              icon: const Icon(Iconsax.add_circle, color: WColors.primary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(WSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Widget
            _buildCalendarCard(),
            const SizedBox(height: WSizes.spaceBtwSections),

            // Events List
            _buildEventsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TableCalendar<CalendarEvent>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        eventLoader: _getEventsForDay,
        startingDayOfWeek: StartingDayOfWeek.monday,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: _onDaySelected,
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: TextStyle(color: Colors.red.shade600),
          holidayTextStyle: TextStyle(color: Colors.red.shade600),
          selectedDecoration: const BoxDecoration(
            color: WColors.primary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: WColors.primary.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonShowsNext: false,
          formatButtonDecoration: BoxDecoration(
            color: WColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          formatButtonTextStyle: const TextStyle(
            color: Colors.white,
          ),
          titleTextStyle: const TextStyle(
            color: WColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          leftChevronIcon: const Icon(
            Iconsax.arrow_left_2,
            color: WColors.primary,
          ),
          rightChevronIcon: const Icon(
            Iconsax.arrow_right_3,
            color: WColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lịch hẹn ngày ${_selectedDay?.day}/${_selectedDay?.month}/${_selectedDay?.year}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: WColors.primary,
          ),
        ),
        const SizedBox(height: WSizes.spaceBtwItems),
        _buildEventsList(),
      ],
    );
  }

  Widget _buildEventsList() {
    final selectedEvents = _getEventsForDay(_selectedDay ?? DateTime.now());

    if (selectedEvents.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(
              Iconsax.calendar_remove,
              size: 60,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Không có sự kiện',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nhấn + để thêm lịch hẹn mới',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: selectedEvents.map((event) => _buildEventCard(event)).toList(),
    );
  }

  Widget _buildEventCard(CalendarEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: WColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Iconsax.calendar_tick,
              color: WColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: WColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Iconsax.location, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Iconsax.clock, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      event.time,
                      style: const TextStyle(
                        color: WColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Iconsax.more, color: WColors.primary),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Iconsax.edit, color: WColors.primary),
                    SizedBox(width: 8),
                    Text('Chỉnh sửa'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Iconsax.trash, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Xóa', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'delete') {
                _deleteEvent(event);
              } else if (value == 'edit') {
                _showEditEventDialog(event);
              }
            },
          ),
        ],
      ),
    );
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _showAddEventDialog() {
    _showEventDialog();
  }

  void _showEditEventDialog(CalendarEvent event) {
    _showEventDialog(event: event);
  }

  void _showEventDialog({CalendarEvent? event}) {
    final titleController = TextEditingController(text: event?.title ?? '');
    final locationController =
        TextEditingController(text: event?.location ?? '');
    final timeController = TextEditingController(text: event?.time ?? '');
    final isEditing = event != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          isEditing ? 'Chỉnh sửa lịch hẹn' : 'Thêm lịch hẹn mới',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: WColors.primary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogTextField(
              controller: titleController,
              label: 'Tiêu đề',
              icon: Iconsax.edit,
              hint: 'Nhập tiêu đề sự kiện',
            ),
            const SizedBox(height: WSizes.spaceBtwInputFields),
            _buildDialogTextField(
              controller: locationController,
              label: 'Địa điểm',
              icon: Iconsax.location,
              hint: 'Nhập địa điểm',
            ),
            const SizedBox(height: WSizes.spaceBtwInputFields),
            _buildDialogTextField(
              controller: timeController,
              label: 'Thời gian',
              icon: Iconsax.clock,
              hint: 'VD: 14:00',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Hủy',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (isEditing) {
                _editEvent(event, titleController.text, locationController.text,
                    timeController.text);
              } else {
                _addEvent(titleController.text, locationController.text,
                    timeController.text);
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: WColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(isEditing ? 'Cập nhật' : 'Thêm'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: WColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: WColors.primary.withOpacity(0.7)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: WColors.primary),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }

  void _addEvent(String title, String location, String time) {
    if (title.isNotEmpty && _selectedDay != null) {
      final eventDate =
          DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);

      setState(() {
        if (_events[eventDate] != null) {
          _events[eventDate]!.add(CalendarEvent(title, location, time));
        } else {
          _events[eventDate] = [CalendarEvent(title, location, time)];
        }
      });

      Get.snackbar(
        'Thành công',
        'Đã thêm lịch hẹn mới',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _editEvent(
      CalendarEvent oldEvent, String title, String location, String time) {
    if (title.isNotEmpty && _selectedDay != null) {
      final eventDate =
          DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);

      setState(() {
        final events = _events[eventDate];
        if (events != null) {
          final index = events.indexOf(oldEvent);
          if (index != -1) {
            events[index] = CalendarEvent(title, location, time);
          }
        }
      });

      Get.snackbar(
        'Đã cập nhật',
        'Lịch hẹn đã được cập nhật',
        backgroundColor: Colors.blue.withOpacity(0.1),
        colorText: Colors.blue,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _deleteEvent(CalendarEvent event) {
    if (_selectedDay != null) {
      final eventDate =
          DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);

      setState(() {
        _events[eventDate]?.remove(event);
        if (_events[eventDate]?.isEmpty == true) {
          _events.remove(eventDate);
        }
      });

      Get.snackbar(
        'Đã xóa',
        'Lịch hẹn đã được xóa',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }
}

class CalendarEvent {
  final String title;
  final String location;
  final String time;

  CalendarEvent(this.title, this.location, this.time);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarEvent &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          location == other.location &&
          time == other.time;

  @override
  int get hashCode => title.hashCode ^ location.hashCode ^ time.hashCode;
}
