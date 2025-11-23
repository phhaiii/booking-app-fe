class BookingSettings {
  final String id;
  final int workStartHour; // 10
  final int workEndHour; // 20
  final int consultantCapacity; // 2
  final int sessionDurationHours; // 2
  final List<String> workingDays; // ['Monday', 'Tuesday', ...]
  final List<String> holidays; // ['2024-01-01', ...]

  BookingSettings({
    required this.id,
    this.workStartHour = 10,
    this.workEndHour = 20,
    this.consultantCapacity = 2,
    this.sessionDurationHours = 2,
    this.workingDays = const [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ],
    this.holidays = const [],
  });

  // ✅ Tính tổng số slots trong ngày (Fixed: 4 slots)
  int get totalSlotsPerDay => 4;

  // ✅ Tổng capacity trong ngày (4 slots, mỗi slot nhận 1 booking)
  int get totalCapacityPerDay => 4; // 4 slots × 1 booking each = 4 bookings/day

  // ✅ Lấy danh sách 4 time slots cố định (mỗi slot capacity = 1)
  List<TimeSlot> get timeSlots {
    return [
      TimeSlot(
        id: 'slot_0',
        startHour: 10,
        endHour: 12,
        capacity: 1, // Chỉ nhận 1 booking
      ),
      TimeSlot(
        id: 'slot_1',
        startHour: 12,
        endHour: 14,
        capacity: 1, // Chỉ nhận 1 booking
      ),
      TimeSlot(
        id: 'slot_2',
        startHour: 14,
        endHour: 16,
        capacity: 1, // Chỉ nhận 1 booking
      ),
      TimeSlot(
        id: 'slot_3',
        startHour: 16,
        endHour: 18,
        capacity: 1, // Chỉ nhận 1 booking
      ),
    ];
  }

  // ✅ Check ngày có làm việc không
  bool isWorkingDay(DateTime date) {
    final dayName = _getDayName(date.weekday);
    return workingDays.contains(dayName) && !isHoliday(date);
  }

  bool isHoliday(DateTime date) {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return holidays.contains(dateStr);
  }

  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1];
  }

  factory BookingSettings.fromJson(Map<String, dynamic> json) {
    return BookingSettings(
      id: json['id'],
      workStartHour: json['workStartHour'] ?? 10,
      workEndHour: json['workEndHour'] ?? 20,
      consultantCapacity: json['consultantCapacity'] ?? 2,
      sessionDurationHours: json['sessionDurationHours'] ?? 2,
      workingDays: List<String>.from(json['workingDays'] ?? []),
      holidays: List<String>.from(json['holidays'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workStartHour': workStartHour,
      'workEndHour': workEndHour,
      'consultantCapacity': consultantCapacity,
      'sessionDurationHours': sessionDurationHours,
      'workingDays': workingDays,
      'holidays': holidays,
    };
  }
}

class TimeSlot {
  final String id;
  final int startHour;
  final int endHour;
  final int capacity;
  int bookedCount = 0;

  TimeSlot({
    required this.id,
    required this.startHour,
    required this.endHour,
    required this.capacity,
    this.bookedCount = 0,
  });

  bool get isAvailable => bookedCount < capacity;
  int get remainingCapacity => capacity - bookedCount;
  double get occupancyRate => bookedCount / capacity;

  String get timeRange =>
      '${startHour.toString().padLeft(2, '0')}:00 - ${endHour.toString().padLeft(2, '0')}:00';

  TimeSlot copyWith({int? bookedCount}) {
    return TimeSlot(
      id: id,
      startHour: startHour,
      endHour: endHour,
      capacity: capacity,
      bookedCount: bookedCount ?? this.bookedCount,
    );
  }
}
