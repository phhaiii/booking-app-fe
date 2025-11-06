import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:booking_app/features/controller/booking_controller.dart';
import 'package:booking_app/models/booking_response.dart';
import 'package:booking_app/utils/constants/colors.dart';

class BookingCalendarWidget extends StatelessWidget {
  final BookingController controller;
  final CalendarFormat calendarFormat;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(CalendarFormat) onFormatChanged;
  final Function(DateTime) onPageChanged;

  const BookingCalendarWidget({
    super.key,
    required this.controller,
    required this.calendarFormat,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
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
      
      child: GetBuilder<BookingController>(
        init: controller,
        builder: (ctrl) => TableCalendar<BookingRequestUI>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: focusedDay,
          calendarFormat: calendarFormat,
          eventLoader: (day) => ctrl.getBookingsForDate(day),
          startingDayOfWeek: StartingDayOfWeek.monday,
          selectedDayPredicate: (day) => isSameDay(selectedDay, day),
          onDaySelected: onDaySelected,
          onFormatChanged: onFormatChanged,
          onPageChanged: onPageChanged,
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
            rightChevronIcon:
                Icon(Icons.chevron_right, color: WColors.primary),
          ),
        ),
      ),
    );
  }
}