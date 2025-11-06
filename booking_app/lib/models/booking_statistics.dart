class BookingStatistics {
  final int totalBookings;
  final int pendingBookings;
  final int confirmedBookings;
  final int rejectedBookings;
  final int completedBookings;
  final int cancelledBookings;
  final int overdueBookings;
  final double totalRevenue;
  final double pendingRevenue;
  final double confirmedRevenue;
  final int venueBookings;
  final int photographyBookings;
  final int cateringBookings;
  final int decorationBookings;
  final int fashionBookings;
  final int todayBookings;
  final int thisWeekBookings;
  final int thisMonthBookings;

  BookingStatistics({
    required this.totalBookings,
    required this.pendingBookings,
    required this.confirmedBookings,
    required this.rejectedBookings,
    required this.completedBookings,
    required this.cancelledBookings,
    required this.overdueBookings,
    required this.totalRevenue,
    required this.pendingRevenue,
    required this.confirmedRevenue,
    required this.venueBookings,
    required this.photographyBookings,
    required this.cateringBookings,
    required this.decorationBookings,
    required this.fashionBookings,
    required this.todayBookings,
    required this.thisWeekBookings,
    required this.thisMonthBookings,
  });

  factory BookingStatistics.fromJson(Map<String, dynamic> json) {
    return BookingStatistics(
      totalBookings: json['totalBookings'] ?? 0,
      pendingBookings: json['pendingBookings'] ?? 0,
      confirmedBookings: json['confirmedBookings'] ?? 0,
      rejectedBookings: json['rejectedBookings'] ?? 0,
      completedBookings: json['completedBookings'] ?? 0,
      cancelledBookings: json['cancelledBookings'] ?? 0,
      overdueBookings: json['overdueBookings'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      pendingRevenue: (json['pendingRevenue'] ?? 0).toDouble(),
      confirmedRevenue: (json['confirmedRevenue'] ?? 0).toDouble(),
      venueBookings: json['venueBookings'] ?? 0,
      photographyBookings: json['photographyBookings'] ?? 0,
      cateringBookings: json['cateringBookings'] ?? 0,
      decorationBookings: json['decorationBookings'] ?? 0,
      fashionBookings: json['fashionBookings'] ?? 0,
      todayBookings: json['todayBookings'] ?? 0,
      thisWeekBookings: json['thisWeekBookings'] ?? 0,
      thisMonthBookings: json['thisMonthBookings'] ?? 0,
    );
  }
}