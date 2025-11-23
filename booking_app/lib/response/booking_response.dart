// Enum cho trạng thái booking
enum BookingStatus { pending, confirmed, rejected, completed, cancelled }

class BookingResponse {
  final int id;
  final String bookingCode;
  final int userId;
  final String customerName;
  final String customerPhone;
  final String? customerEmail;
  final int? postId;
  final int vendorId;
  final int venueId;
  final int? menuId;
  final DateTime bookingDate;
  final DateTime startTime;
  final DateTime endTime;
  final int slotIndex;
  final double? durationHours;
  final int numberOfGuests;
  final double unitPrice;
  final double totalAmount;
  final double finalAmount;
  final String currency;
  final String? specialRequests;
  final String status;
  final int? cancelledBy;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final int? rejectedBy;
  final DateTime? rejectedAt;
  final String? rejectionReason;
  final int? confirmedBy;
  final DateTime? confirmedAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  // Extra fields for UI
  final String? venueName;
  final String? venueImage;
  final String? menuName;

  BookingResponse({
    required this.id,
    required this.bookingCode,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    this.customerEmail,
    this.postId,
    required this.vendorId,
    required this.venueId,
    this.menuId,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.slotIndex,
    this.durationHours,
    required this.numberOfGuests,
    required this.unitPrice,
    required this.totalAmount,
    required this.finalAmount,
    this.currency = 'VND',
    this.specialRequests,
    this.status = 'PENDING',
    this.cancelledBy,
    this.cancelledAt,
    this.cancellationReason,
    this.rejectedBy,
    this.rejectedAt,
    this.rejectionReason,
    this.confirmedBy,
    this.confirmedAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.venueName,
    this.venueImage,
    this.menuName,
  });

  // Helper function to parse time strings and combine with booking date
  static DateTime _parseTimeWithDate(String? timeStr, DateTime bookingDate) {
    if (timeStr == null) return bookingDate;

    // If it's already a full datetime string, parse it directly
    if (timeStr.contains('T') || timeStr.length > 10) {
      try {
        return DateTime.parse(timeStr);
      } catch (_) {
        // Continue to time-only parsing
      }
    }

    // Parse time-only format (HH:mm:ss)
    try {
      final timeParts = timeStr.split(':');
      if (timeParts.length >= 2) {
        final hours = int.parse(timeParts[0]);
        final minutes = int.parse(timeParts[1]);
        final seconds = timeParts.length > 2 ? int.parse(timeParts[2]) : 0;

        return DateTime(
          bookingDate.year,
          bookingDate.month,
          bookingDate.day,
          hours,
          minutes,
          seconds,
        );
      }
    } catch (e) {
      print('⚠️ Error parsing time: $timeStr - $e');
    }

    return bookingDate;
  }

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    // Debug: Check what backend sends
    print('🔍 BookingResponse.fromJson DEBUG:');
    print('   JSON keys: ${json.keys.toList()}');
    print('   Full JSON: $json');

    // Handle minimal response (only slotIndex and status)
    if (json.keys.length <= 3 && json.containsKey('slotIndex')) {
      print('⚠️ Minimal booking response detected - creating default object');
      return BookingResponse(
        id: 0,
        bookingCode: '',
        userId: 0,
        customerName: '',
        customerPhone: '',
        vendorId: 0,
        venueId: 0,
        bookingDate: DateTime.now(),
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        slotIndex: json['slotIndex'] ?? 0,
        numberOfGuests: 0,
        specialRequests: '',
        unitPrice: 0,
        totalAmount: 0,
        finalAmount: 0,
        status: json['status'] ?? 'PENDING',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    // Full booking response
    final bookingDate =
        DateTime.parse(json['bookingDate'] ?? json['booking_date']);

    print('   startTime from JSON: ${json['startTime'] ?? json['start_time']}');
    print('   endTime from JSON: ${json['endTime'] ?? json['end_time']}');
    print(
        '   bookingDate from JSON: ${json['bookingDate'] ?? json['booking_date']}');

    return BookingResponse(
      id: json['id'] ?? 0,
      bookingCode: json['bookingCode'] ?? json['booking_code'] ?? '',
      userId: json['userId'] ?? json['user_id'] ?? 0,
      customerName: json['customerName'] ?? json['customer_name'] ?? '',
      customerPhone: json['customerPhone'] ?? json['customer_phone'] ?? '',
      customerEmail: json['customerEmail'] ?? json['customer_email'],
      postId: json['postId'] ?? json['post_id'],
      vendorId: json['vendorId'] ?? json['vendor_id'] ?? 0,
      venueId: json['venueId'] ?? json['venue_id'] ?? 0,
      menuId: json['menuId'] ?? json['menu_id'],
      bookingDate: bookingDate,
      startTime: _parseTimeWithDate(
          json['startTime'] ?? json['start_time'], bookingDate),
      endTime:
          _parseTimeWithDate(json['endTime'] ?? json['end_time'], bookingDate),
      slotIndex: json['slotIndex'] ?? json['slot_index'] ?? 0,
      durationHours: json['durationHours'] != null
          ? (json['durationHours']).toDouble()
          : (json['duration_hours'])?.toDouble(),
      numberOfGuests: json['number_of_guests'] ?? json['numberOfGuests'] ?? 0,
      unitPrice: (json['unitPrice'] ?? json['unit_price'] ?? 0).toDouble(),
      totalAmount:
          (json['totalAmount'] ?? json['total_amount'] ?? 0).toDouble(),
      finalAmount:
          (json['finalAmount'] ?? json['final_amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'VND',
      specialRequests:
          json['specialRequests'] ?? json['special_requests'] ?? json['special_requests'],
      status: json['status'] ?? 'PENDING',
      cancelledBy: json['cancelledBy'] ?? json['cancelled_by'],
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'])
          : (json['cancelled_at'] != null
              ? DateTime.parse(json['cancelled_at'])
              : null),
      cancellationReason:
          json['cancellationReason'] ?? json['cancellation_reason'],
      rejectedBy: json['rejectedBy'] ?? json['rejected_by'],
      rejectedAt: json['rejectedAt'] != null
          ? DateTime.parse(json['rejectedAt'])
          : (json['rejected_at'] != null
              ? DateTime.parse(json['rejected_at'])
              : null),
      rejectionReason: json['rejectionReason'] ?? json['rejection_reason'],
      confirmedBy: json['confirmedBy'] ?? json['confirmed_by'],
      confirmedAt: json['confirmedAt'] != null
          ? DateTime.parse(json['confirmedAt'])
          : (json['confirmed_at'] != null
              ? DateTime.parse(json['confirmed_at'])
              : null),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : (json['completed_at'] != null
              ? DateTime.parse(json['completed_at'])
              : null),
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at']),
      updatedAt: DateTime.parse(json['updatedAt'] ?? json['updated_at']),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : (json['deleted_at'] != null
              ? DateTime.parse(json['deleted_at'])
              : null),
      venueName: json['venueName'],
      venueImage: json['venueImage'],
      menuName: json['menuName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'bookingCode': bookingCode,
      'userId': userId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'vendorId': vendorId,
      'venueId': venueId,
      'bookingDate': bookingDate.toIso8601String(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'slotIndex': slotIndex,
      'special_requests': specialRequests,
      'number_of_guests': numberOfGuests,
      'unitPrice': unitPrice,
      'totalAmount': totalAmount,
      'finalAmount': finalAmount,
      'currency': currency,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };

    if (customerEmail != null) data['customerEmail'] = customerEmail;
    if (postId != null) data['postId'] = postId;
    if (menuId != null) data['menuId'] = menuId;
    if (durationHours != null) data['durationHours'] = durationHours;
    if (specialRequests != null) data['specialRequests'] = specialRequests;
    if (cancelledBy != null) data['cancelledBy'] = cancelledBy;
    if (cancelledAt != null)
      data['cancelledAt'] = cancelledAt!.toIso8601String();
    if (cancellationReason != null)
      data['cancellationReason'] = cancellationReason;
    if (confirmedBy != null) data['confirmedBy'] = confirmedBy;
    if (confirmedAt != null)
      data['confirmedAt'] = confirmedAt!.toIso8601String();
    if (completedAt != null)
      data['completedAt'] = completedAt!.toIso8601String();
    if (deletedAt != null) data['deletedAt'] = deletedAt!.toIso8601String();
    if (venueName != null) data['venueName'] = venueName;
    if (venueImage != null) data['venueImage'] = venueImage;
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
  bool get isRejected => status.toUpperCase() == 'REJECTED';

  // Convert String status to BookingStatus enum
  BookingStatus get statusEnum {
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

  // Getters for convenience and UI compatibility
  int get effectiveGuestCount => numberOfGuests;
  String get note => specialRequests ?? '';
  String? get message => specialRequests;
  String get serviceName => venueName ?? 'Venue';
  String get serviceType => 'VENUE';
  DateTime get requestedDate => startTime;
  double? get budget => finalAmount;

  // Copy with method for updating
  BookingResponse copyWith({
    int? id,
    String? bookingCode,
    int? userId,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    int? postId,
    int? vendorId,
    int? venueId,
    int? menuId,
    DateTime? bookingDate,
    DateTime? startTime,
    DateTime? endTime,
    int? slotIndex,
    double? durationHours,
    int? numberOfGuests,
    int? guestCount,
    double? unitPrice,
    double? totalAmount,
    double? finalAmount,
    String? currency,
    String? specialRequests,
    String? status,
    int? cancelledBy,
    DateTime? cancelledAt,
    String? cancellationReason,
    int? confirmedBy,
    DateTime? confirmedAt,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? venueName,
    String? venueImage,
    String? menuName,
  }) {
    return BookingResponse(
      id: id ?? this.id,
      bookingCode: bookingCode ?? this.bookingCode,
      userId: userId ?? this.userId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      postId: postId ?? this.postId,
      vendorId: vendorId ?? this.vendorId,
      venueId: venueId ?? this.venueId,
      menuId: menuId ?? this.menuId,
      bookingDate: bookingDate ?? this.bookingDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      slotIndex: slotIndex ?? this.slotIndex,
      durationHours: durationHours ?? this.durationHours,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      unitPrice: unitPrice ?? this.unitPrice,
      totalAmount: totalAmount ?? this.totalAmount,
      finalAmount: finalAmount ?? this.finalAmount,
      currency: currency ?? this.currency,
      specialRequests: specialRequests ?? this.specialRequests,
      status: status ?? this.status,
      cancelledBy: cancelledBy ?? this.cancelledBy,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      confirmedBy: confirmedBy ?? this.confirmedBy,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      venueName: venueName ?? this.venueName,
      venueImage: venueImage ?? this.venueImage,
      menuName: menuName ?? this.menuName,
    );
  }
}

// Booking Update Request
class BookingUpdateRequest {
  final DateTime? bookingDate;
  final int? guestCount;
  final String? specialRequests;
  final String? status;
  final int? menuId;

  BookingUpdateRequest({
    this.bookingDate,
    this.guestCount,
    this.specialRequests,
    this.status,
    this.menuId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (bookingDate != null)
      data['bookingDate'] = bookingDate!.toIso8601String();
    if (guestCount != null) data['number_of_guests'] = guestCount;
    if (specialRequests != null) data['specialRequests'] = specialRequests;
    if (status != null) data['status'] = status;
    if (menuId != null) data['menuId'] = menuId;
    return data;
  }
}
