import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/models/booking_response.dart';

class BookingHelper {
  static Color getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.rejected:
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.completed:
        return Colors.blue;
    }
  }

  static String getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'Chờ xử lý';
      case BookingStatus.confirmed:
        return 'Đã xác nhận';
      case BookingStatus.rejected:
      case BookingStatus.cancelled:
        return 'Đã từ chối';
      case BookingStatus.completed:
        return 'Hoàn thành';
    }
  }

  static IconData getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Iconsax.clock;
      case BookingStatus.confirmed:
        return Iconsax.tick_circle;
      case BookingStatus.rejected:
      case BookingStatus.cancelled:
        return Iconsax.close_circle;
      case BookingStatus.completed:
        return Iconsax.tick_circle;
    }
  }

  static IconData getServiceIcon(String serviceType) {
    final type = serviceType.toUpperCase();
    switch (type) {
      case 'VENUE':
        return Iconsax.building;
      case 'PHOTOGRAPHY':
        return Iconsax.camera;
      case 'CATERING':
        return Iconsax.cup;
      case 'DECORATION':
        return Iconsax.brush_1;
      case 'FASHION':
        return Iconsax.user_octagon;
      default:
        return Iconsax.note;
    }
  }

  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static String formatCreatedTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Vừa xong';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  static String formatPrice(double price) {
    if (price >= 1000000) {
      final millions = price / 1000000;
      if (millions == millions.toInt()) {
        return '${millions.toInt()} triệu';
      }
      return '${millions.toStringAsFixed(1)} triệu';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}k';
    }
    return price.toStringAsFixed(0);
  }
}