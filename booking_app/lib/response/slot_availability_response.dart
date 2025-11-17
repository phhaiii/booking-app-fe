/// Response model for slot availability information
/// Matches SlotAvailabilityResponse from Java backend
class SlotAvailabilityResponse {
  final int totalSlots;
  final int availableSlots;
  final int bookedSlots;
  final List<TimeSlotInfo> timeSlots;

  SlotAvailabilityResponse({
    required this.totalSlots,
    required this.availableSlots,
    required this.bookedSlots,
    required this.timeSlots,
  });

  factory SlotAvailabilityResponse.fromJson(Map<String, dynamic> json) {
    return SlotAvailabilityResponse(
      totalSlots: json['totalSlots'] ?? 0,
      availableSlots: json['availableSlots'] ?? 0,
      bookedSlots: json['bookedSlots'] ?? 0,
      timeSlots: (json['timeSlots'] as List<dynamic>?)
              ?.map((slot) => TimeSlotInfo.fromJson(slot))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSlots': totalSlots,
      'availableSlots': availableSlots,
      'bookedSlots': bookedSlots,
      'timeSlots': timeSlots.map((slot) => slot.toJson()).toList(),
    };
  }

  bool get hasAvailableSlots => availableSlots > 0;
  bool get isFullyBooked => availableSlots == 0;
  double get occupancyRate => totalSlots > 0 ? bookedSlots / totalSlots : 0.0;
}

/// Individual time slot information
class TimeSlotInfo {
  final String slot; // e.g., "MORNING", "AFTERNOON", "EVENING", "NIGHT"
  final String timeRange; // e.g., "10:00-14:00"
  final bool available;
  final int capacity;
  final int booked;

  TimeSlotInfo({
    required this.slot,
    required this.timeRange,
    required this.available,
    required this.capacity,
    required this.booked,
  });

  factory TimeSlotInfo.fromJson(Map<String, dynamic> json) {
    return TimeSlotInfo(
      slot: json['slot'] ?? '',
      timeRange: json['timeRange'] ?? '',
      available: json['available'] ?? false,
      capacity: json['capacity'] ?? 0,
      booked: json['booked'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slot': slot,
      'timeRange': timeRange,
      'available': available,
      'capacity': capacity,
      'booked': booked,
    };
  }

  int get remainingSlots => capacity - booked;
  bool get isFull => booked >= capacity;
  double get utilizationRate => capacity > 0 ? booked / capacity : 0.0;

  String get slotDisplay {
    switch (slot.toUpperCase()) {
      case 'MORNING':
        return 'Buổi sáng';
      case 'AFTERNOON':
        return 'Buổi chiều';
      case 'EVENING':
        return 'Buổi tối';
      case 'NIGHT':
        return 'Buổi đêm';
      default:
        return slot;
    }
  }
}
