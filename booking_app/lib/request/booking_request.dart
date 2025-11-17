class BookingRequest {
  final int venueId;
  final DateTime bookingDate;
  final int guestCount;
  final String customerName;
  final String customerPhone;
  final String? note;
  final int? menuId;

  // ✅ NEW: Required fields for backend
  final int postId;
  final double unitPrice;
  final DateTime startTime;
  final DateTime endTime;
  final int slotIndex; // ✅ CRITICAL: Slot index is required by backend

  BookingRequest({
    required this.venueId,
    required this.bookingDate,
    required this.guestCount,
    required this.customerName,
    required this.customerPhone,
    this.note,
    this.menuId,
    required this.postId,
    required this.unitPrice,
    required this.startTime,
    required this.endTime,
    required this.slotIndex,
  });

  // Map đúng với backend BookingRequest (camelCase for DTO validation)
  Map<String, dynamic> toJson() {
    return {
      'venueId': venueId,
      'bookingDate': bookingDate.toIso8601String(),
      'guestCount': guestCount,
      'customerName': customerName,
      'customerPhone': customerPhone,
      if (note != null && note!.isNotEmpty) 'note': note,
      if (menuId != null) 'menuId': menuId,
      'postId': postId,
      'unitPrice': unitPrice,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'slotIndex': slotIndex, // ✅ CRITICAL: Backend validation requires this
    };
  }

  factory BookingRequest.fromJson(Map<String, dynamic> json) {
    return BookingRequest(
      venueId: json['venue_id'] ?? json['venueId'] ?? 0,
      bookingDate: DateTime.parse(json['booking_date'] ?? json['bookingDate']),
      guestCount: json['number_of_guests'] ?? json['guestCount'] ?? 1,
      customerName: json['customer_name'] ?? json['customerName'] ?? '',
      customerPhone: json['customer_phone'] ?? json['customerPhone'] ?? '',
      note: json['special_requests'] ?? json['note'],
      menuId: json['menu_id'] ?? json['menuId'],
      postId: json['post_id'] ?? json['postId'] ?? 0,
      unitPrice: (json['unit_price'] ?? json['unitPrice'] ?? 0).toDouble(),
      startTime: DateTime.parse(json['start_time'] ?? json['startTime']),
      endTime: DateTime.parse(json['end_time'] ?? json['endTime']),
      slotIndex: json['slot_index'] ?? json['slotIndex'] ?? 0,
    );
  }
}
