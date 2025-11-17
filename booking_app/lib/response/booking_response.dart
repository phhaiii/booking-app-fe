// Enum cho trạng thái booking
enum BookingStatus { pending, confirmed, rejected, completed, cancelled }

class BookingResponse {
  final int id;
  final int userId;
  final int venueId;
  final String? venueName;
  final String? venueImage;
  final DateTime bookingDate;
  final String status;
  final int guestCount;
  final double totalPrice;
  final String? note;
  final int? menuId;
  final String? menuName;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingResponse({
    required this.id,
    required this.userId,
    required this.venueId,
    this.venueName,
    this.venueImage,
    required this.bookingDate,
    required this.status,
    required this.guestCount,
    required this.totalPrice,
    this.note,
    this.menuId,
    this.menuName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      venueId: json['venueId'] ?? 0,
      venueName: json['venueName'],
      venueImage: json['venueImage'],
      bookingDate: DateTime.parse(json['bookingDate']),
      status: json['status'] ?? 'PENDING',
      guestCount: json['guestCount'] ?? json['numberOfGuests'] ?? 1,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      note: json['note'],
      menuId: json['menuId'],
      menuName: json['menuName'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'userId': userId,
      'venueId': venueId,
      'bookingDate': bookingDate.toIso8601String(),
      'status': status,
      'guestCount': guestCount,
      'totalPrice': totalPrice,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };

    if (venueName != null) data['venueName'] = venueName;
    if (venueImage != null) data['venueImage'] = venueImage;
    if (note != null) data['note'] = note;
    if (menuId != null) data['menuId'] = menuId;
    if (menuName != null) data['menuName'] = menuName;

    return data;
  }

  // Helper getters
  String get statusDisplay {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Chờ xác nhận';
      case 'CONFIRMED':
        return 'Đã xác nhận';
      case 'COMPLETED':
        return 'Hoàn thành';
      case 'CANCELLED':
        return 'Đã hủy';
      default:
        return status;
    }
  }

  String get formattedDate {
    return '${bookingDate.day}/${bookingDate.month}/${bookingDate.year}';
  }

  String get formattedDateTime {
    return '${bookingDate.day}/${bookingDate.month}/${bookingDate.year} ${bookingDate.hour}:${bookingDate.minute.toString().padLeft(2, '0')}';
  }

  bool get isPending => status.toUpperCase() == 'PENDING';
  bool get isConfirmed => status.toUpperCase() == 'CONFIRMED';
  bool get isCompleted => status.toUpperCase() == 'COMPLETED';
  bool get isCancelled => status.toUpperCase() == 'CANCELLED';

  // Convert sang BookingRequestUI để tương thích với code cũ
  BookingRequestUI toBookingRequestUI() {
    return BookingRequestUI(
      id: id.toString(),
      customerName: '', // Backend mới không có field này
      customerPhone: '',
      customerEmail: '',
      venueId: venueId,
      venueName: venueName,
      serviceName: venueName ?? 'Venue',
      serviceType: 'VENUE',
      requestedDate: bookingDate,
      numberOfGuests: guestCount,
      budget: totalPrice, // Sử dụng totalPrice từ backend
      message: note,
      status: _parseStatus(status),
      vendorId: null,
      menuId: menuId,
      createdAt: createdAt,
      confirmedAt: status.toUpperCase() == 'CONFIRMED' ? updatedAt : null,
      rejectedAt: status.toUpperCase() == 'REJECTED' ? updatedAt : null,
    );
  }

  static BookingStatus _parseStatus(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return BookingStatus.pending;
      case 'CONFIRMED':
        return BookingStatus.confirmed;
      case 'COMPLETED':
        return BookingStatus.completed;
      case 'CANCELLED':
        return BookingStatus.cancelled;
      case 'REJECTED':
        return BookingStatus.rejected;
      default:
        return BookingStatus.pending;
    }
  }

  // Copy with method for updating
  BookingResponse copyWith({
    int? id,
    int? userId,
    int? venueId,
    String? venueName,
    String? venueImage,
    DateTime? bookingDate,
    String? status,
    int? guestCount,
    double? totalPrice,
    String? note,
    int? menuId,
    String? menuName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookingResponse(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      venueId: venueId ?? this.venueId,
      venueName: venueName ?? this.venueName,
      venueImage: venueImage ?? this.venueImage,
      bookingDate: bookingDate ?? this.bookingDate,
      status: status ?? this.status,
      guestCount: guestCount ?? this.guestCount,
      totalPrice: totalPrice ?? this.totalPrice,
      note: note ?? this.note,
      menuId: menuId ?? this.menuId,
      menuName: menuName ?? this.menuName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Booking Update Request (để update booking)
class BookingUpdateRequest {
  final DateTime? bookingDate;
  final int? guestCount;
  final String? note;
  final String? status;
  final int? menuId;

  BookingUpdateRequest({
    this.bookingDate,
    this.guestCount,
    this.note,
    this.status,
    this.menuId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (bookingDate != null)
      data['bookingDate'] = bookingDate!.toIso8601String();
    if (guestCount != null) data['guestCount'] = guestCount;
    if (note != null) data['note'] = note;
    if (status != null) data['status'] = status;
    if (menuId != null) data['menuId'] = menuId;
    return data;
  }
}

// BookingRequestUI - Để tương thích với code UI cũ
class BookingRequestUI {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final int? venueId;
  final String? venueName;
  final String serviceName;
  final String serviceType;
  final DateTime requestedDate;
  final int? numberOfGuests;
  final double? budget;
  final String? message;
  BookingStatus status;
  final int? vendorId;
  final int? menuId;
  final DateTime createdAt;
  DateTime? confirmedAt;
  DateTime? rejectedAt;

  BookingRequestUI({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    this.venueId,
    this.venueName,
    required this.serviceName,
    required this.serviceType,
    required this.requestedDate,
    this.numberOfGuests,
    this.budget,
    this.message,
    required this.status,
    this.vendorId,
    this.menuId,
    required this.createdAt,
    this.confirmedAt,
    this.rejectedAt,
  });

  // Helper methods cho UI
  bool get isPending => status == BookingStatus.pending;
  bool get isConfirmed => status == BookingStatus.confirmed;
  bool get isRejected => status == BookingStatus.rejected;
  bool get isCancelled => status == BookingStatus.cancelled;
  bool get isCompleted => status == BookingStatus.completed;

  String get statusDisplay {
    switch (status) {
      case BookingStatus.pending:
        return 'Chờ xác nhận';
      case BookingStatus.confirmed:
        return 'Đã xác nhận';
      case BookingStatus.completed:
        return 'Hoàn thành';
      case BookingStatus.cancelled:
        return 'Đã hủy';
      case BookingStatus.rejected:
        return 'Đã từ chối';
    }
  }

  String get formattedDate {
    return '${requestedDate.day}/${requestedDate.month}/${requestedDate.year}';
  }

  String get formattedDateTime {
    final hour = requestedDate.hour.toString().padLeft(2, '0');
    final minute = requestedDate.minute.toString().padLeft(2, '0');
    return '$formattedDate $hour:$minute';
  }
}
