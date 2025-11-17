import 'package:intl/intl.dart';

class CurrencyFormatter {
  /// Format số tiền sang VNĐ: 1000000 → 1.000.000₫
  static String formatVND(num amount) {
    return NumberFormat.currency(
      locale: 'vi',
      symbol: '₫',
      decimalDigits: 0,
    ).format(amount);
  }

  /// Format số tiền sang VNĐ với text: 1000000 → 1.000.000 VNĐ
  static String formatVNDText(num amount) {
    return NumberFormat.currency(
      locale: 'vi',
      symbol: 'VNĐ',
      decimalDigits: 0,
    ).format(amount);
  }

  /// Format số tiền rút gọn: 1000000 → 1tr
  static String formatCompact(num amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}tỷ';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}tr';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}k';
    }
    return amount.toString();
  }

  /// Format số tiền per khách: 500000 → 500.000₫/khách
  static String formatPerGuest(num amount) {
    return '${formatVND(amount)}/khách';
  }

  /// Format số tiền per bàn: 5000000 → 5.000.000₫/bàn
  static String formatPerTable(num amount) {
    return '${formatVND(amount)}/bàn';
  }

  /// Parse string sang number: "1.000.000" → 1000000
  static num? parse(String text) {
    try {
      final cleanText = text.replaceAll(RegExp(r'[^\d]'), '');
      return num.tryParse(cleanText);
    } catch (e) {
      return null;
    }
  }
}