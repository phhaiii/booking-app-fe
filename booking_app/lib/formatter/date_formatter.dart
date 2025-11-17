import 'package:intl/intl.dart';

class DateFormatter {
  // Vietnamese day names
  static const List<String> _dayNames = [
    'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ nhật'
  ];

  static const List<String> _monthNames = [
    'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
    'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'
  ];

  /// Format: Thứ 2, 01/01/2024 - 10:30
  static String formatFullDateTime(DateTime dateTime) {
    final dayOfWeek = dateTime.weekday == 7 
        ? _dayNames[6] 
        : _dayNames[dateTime.weekday - 1];
    
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    
    return '$dayOfWeek, $day/$month/$year - $hour:$minute';
  }

  /// Format: 01/01/2024
  static String formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  /// Format: 10:30
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Format: 01/01/2024 - 10:30
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy - HH:mm').format(dateTime);
  }

  /// Format: Thứ 2, 01 Tháng 1, 2024
  static String formatFullDate(DateTime dateTime) {
    final dayOfWeek = dateTime.weekday == 7 
        ? _dayNames[6] 
        : _dayNames[dateTime.weekday - 1];
    
    final day = dateTime.day;
    final month = _monthNames[dateTime.month - 1];
    final year = dateTime.year;
    
    return '$dayOfWeek, $day $month, $year';
  }

  /// Format: 2 giờ trước, 3 ngày trước, etc.
  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Vừa xong';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} tuần trước';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} tháng trước';
    } else {
      return '${(difference.inDays / 365).floor()} năm trước';
    }
  }
}