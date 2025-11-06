class BookingResponse {
  final int id;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final int? venueId;
  final String? venueName;
  final String serviceName;
  final String serviceType;
  final String serviceTypeDisplay;
  final DateTime requestedDate;
  final int? numberOfGuests;
  final double? budget;
  final String? message;
  final String status;
  final String statusDisplay;
  final String? rejectionReason;
  final int? vendorId;
  final String? vendorName;
  final int? userId;
  final String? userName;
  final DateTime? confirmedAt;
  final DateTime? rejectedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? timeAgo;
  final bool? isOverdue;

  BookingResponse({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    this.venueId,
    this.venueName,
    required this.serviceName,
    required this.serviceType,
    required this.serviceTypeDisplay,
    required this.requestedDate,
    this.numberOfGuests,
    this.budget,
    this.message,
    required this.status,
    required this.statusDisplay,
    this.rejectionReason,
    this.vendorId,
    this.vendorName,
    this.userId,
    this.userName,
    this.confirmedAt,
    this.rejectedAt,
    this.completedAt,
    this.cancelledAt,
    required this.createdAt,
    required this.updatedAt,
    this.timeAgo,
    this.isOverdue,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      id: json['id'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerEmail: json['customerEmail'],
      venueId: json['venueId'],
      venueName: json['venueName'],
      serviceName: json['serviceName'],
      serviceType: json['serviceType'],
      serviceTypeDisplay: json['serviceTypeDisplay'],
      requestedDate: DateTime.parse(json['requestedDate']),
      numberOfGuests: json['numberOfGuests'],
      budget: json['budget']?.toDouble(),
      message: json['message'],
      status: json['status'],
      statusDisplay: json['statusDisplay'],
      rejectionReason: json['rejectionReason'],
      vendorId: json['vendorId'],
      vendorName: json['vendorName'],
      userId: json['userId'],
      userName: json['userName'],
      confirmedAt: json['confirmedAt'] != null ? DateTime.parse(json['confirmedAt']) : null,
      rejectedAt: json['rejectedAt'] != null ? DateTime.parse(json['rejectedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      cancelledAt: json['cancelledAt'] != null ? DateTime.parse(json['cancelledAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      timeAgo: json['timeAgo'],
      isOverdue: json['isOverdue'],
    );
  }

  // Convert to local BookingRequest model for UI
  BookingRequestUI toBookingRequestUI() {
    return BookingRequestUI(
      id: id.toString(),
      customerName: customerName,
      customerPhone: customerPhone,
      customerEmail: customerEmail,
      serviceName: serviceName,
      serviceType: serviceType,
      requestedDate: requestedDate,
      numberOfGuests: numberOfGuests,
      budget: budget,
      message: message,
      status: _mapStatus(status),
      createdAt: createdAt,
      confirmedAt: confirmedAt,
      rejectedAt: rejectedAt,
    );
  }

  BookingStatus _mapStatus(String status) {
    switch (status) {
      case 'PENDING':
        return BookingStatus.pending;
      case 'CONFIRMED':
        return BookingStatus.confirmed;
      case 'REJECTED':
        return BookingStatus.rejected;
      case 'COMPLETED':
        return BookingStatus.completed;
      case 'CANCELLED':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.pending;
    }
  }
}

// Local UI model
class BookingRequestUI {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String serviceName;
  final String serviceType;
  final DateTime requestedDate;
  final int? numberOfGuests;
  final double? budget;
  final String? message;
  BookingStatus status;
  final DateTime createdAt;
  DateTime? confirmedAt;
  DateTime? rejectedAt;

  BookingRequestUI({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.serviceName,
    required this.serviceType,
    required this.requestedDate,
    this.numberOfGuests,
    this.budget,
    this.message,
    required this.status,
    required this.createdAt,
    this.confirmedAt,
    this.rejectedAt,
  });
}

enum BookingStatus { pending, confirmed, rejected, completed, cancelled }