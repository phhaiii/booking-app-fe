import 'package:booking_app/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NotificationUtils {
  static Color getAppointmentStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.confirmed:
        return Colors.green;
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.cancelled:
        return Colors.red;
      case AppointmentStatus.completed:
        return Colors.blue;
      case AppointmentStatus.rescheduled:
        return Colors.purple;
    }
  }

  static IconData getAppointmentStatusIcon(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.confirmed:
        return Iconsax.tick_circle;
      case AppointmentStatus.pending:
        return Iconsax.clock;
      case AppointmentStatus.cancelled:
        return Iconsax.close_circle;
      case AppointmentStatus.completed:
        return Iconsax.tick_square;
      case AppointmentStatus.rescheduled:
        return Iconsax.calendar_edit;
    }
  }

  static String getAppointmentStatusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.confirmed:
        return 'ĐÃ XÁC NHẬN';
      case AppointmentStatus.pending:
        return 'CHỜ XÁC NHẬN';
      case AppointmentStatus.cancelled:
        return 'ĐÃ HỦY';
      case AppointmentStatus.completed:
        return 'HOÀN THÀNH';
      case AppointmentStatus.rescheduled:
        return 'ĐÃ ĐỔI LỊCH';
    }
  }

  static String formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}