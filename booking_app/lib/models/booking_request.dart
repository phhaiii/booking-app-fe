class BookingRequest {
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final int? venueId;
  final String serviceName;
  final String serviceType;
  final DateTime requestedDate;
  final int? numberOfGuests;
  final double? budget;
  final String? message;
  final int? vendorId;

  BookingRequest({
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    this.venueId,
    required this.serviceName,
    required this.serviceType,
    required this.requestedDate,
    this.numberOfGuests,
    this.budget,
    this.message,
    this.vendorId,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'venueId': venueId,
      'serviceName': serviceName,
      'serviceType': serviceType,
      'requestedDate': requestedDate.toIso8601String(),
      'numberOfGuests': numberOfGuests,
      'budget': budget,
      'message': message,
      'vendorId': vendorId,
    };
  }
}