/// Response model for slot availability information
/// Matches SlotAvailabilityResponse from Java backend
class SlotAvailabilityResponse {
  final int postId;
  final String date;
  final int totalSlots;
  final int availableCount;
  final int bookedCount;
  final double occupancyPercentage;
  final List<TimeSlotInfo> slots;

  SlotAvailabilityResponse({
    required this.postId,
    required this.date,
    required this.totalSlots,
    required this.availableCount,
    required this.bookedCount,
    required this.occupancyPercentage,
    required this.slots,
  });

  factory SlotAvailabilityResponse.fromJson(Map<String, dynamic> json) {
    // Support both old and new field names
    final totalSlots = json['totalSlots'] ?? 0;
    final availableCount =
        json['availableCount'] ?? json['availableSlots'] ?? 0;
    final bookedCount = json['bookedCount'] ?? json['bookedSlots'] ?? 0;

    return SlotAvailabilityResponse(
      postId: json['postId'] ?? 0,
      date: json['date'] ?? '',
      totalSlots: totalSlots,
      availableCount: availableCount,
      bookedCount: bookedCount,
      occupancyPercentage: (json['occupancyPercentage'] ??
              (totalSlots > 0 ? (bookedCount / totalSlots * 100) : 0.0))
          .toDouble(),
      slots: (json['slots'] as List<dynamic>?)
              ?.map((slot) => TimeSlotInfo.fromJson(slot))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'date': date,
      'totalSlots': totalSlots,
      'availableCount': availableCount,
      'bookedCount': bookedCount,
      'occupancyPercentage': occupancyPercentage,
      'slots': slots.map((slot) => slot.toJson()).toList(),
    };
  }

  bool get hasAvailableSlots => availableCount > 0;
  bool get isFullyBooked => availableCount == 0;
  double get occupancyRate => occupancyPercentage / 100.0;

  // Backward compatibility
  int get availableSlots => availableCount;
  int get bookedSlots => bookedCount;
  List<TimeSlotInfo> get timeSlots => slots;
}

/// Individual time slot information
class TimeSlotInfo {
  final int index;
  final String startTime;
  final String endTime;
  final String displayText;
  final bool isAvailable;
  final String? bookingCode;

  TimeSlotInfo({
    required this.index,
    required this.startTime,
    required this.endTime,
    required this.displayText,
    required this.isAvailable,
    this.bookingCode,
  });

  factory TimeSlotInfo.fromJson(Map<String, dynamic> json) {
    // Support both 'index' and 'slotIndex' field names
    final slotIndex = json['slotIndex'] ?? json['index'] ?? 0;

    // Support both 'isAvailable' boolean and 'status' string
    bool isAvailable;
    if (json.containsKey('isAvailable')) {
      isAvailable = json['isAvailable'] ?? false;
    } else if (json.containsKey('status')) {
      // If status is 'AVAILABLE' or 'FREE', then available = true
      final status = json['status']?.toString().toUpperCase() ?? '';
      isAvailable = status == 'AVAILABLE' || status == 'FREE';
    } else {
      isAvailable = false;
    }

    return TimeSlotInfo(
      index: slotIndex,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      displayText: json['displayText'] ?? '',
      isAvailable: isAvailable,
      bookingCode: json['bookingCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'startTime': startTime,
      'endTime': endTime,
      'displayText': displayText,
      'isAvailable': isAvailable,
      'bookingCode': bookingCode,
    };
  }

  bool get isBooked => !isAvailable;

  // Backward compatibility getters
  String get slot => 'SLOT_$index';
  String get timeRange => displayText;
  bool get available => isAvailable;
  int get capacity => 1;
  int get booked => isAvailable ? 0 : 1;
  int get remainingSlots => isAvailable ? 1 : 0;
  bool get isFull => !isAvailable;
  double get utilizationRate => isAvailable ? 0.0 : 1.0;

  String get slotDisplay => displayText;
}
