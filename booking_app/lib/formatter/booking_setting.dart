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

  // ✅ Tính tổng số slots trong ngày
  int get totalSlotsPerDay {
    final workHours = workEndHour - workStartHour; // 20 - 10 = 10 giờ
    return (workHours / sessionDurationHours).floor(); // 10 / 2 = 5 slots
  }

  // ✅ Tổng capacity trong ngày
  int get totalCapacityPerDay {
    return totalSlotsPerDay * consultantCapacity; // 5 slots * 2 = 10 bookings/day
  }

  // ✅ Lấy danh sách time slots
  List<TimeSlot> get timeSlots {
    final slots = <TimeSlot>[];
    for (int i = 0; i < totalSlotsPerDay; i++) {
      final startHour = workStartHour + (i * sessionDurationHours);
      final endHour = startHour + sessionDurationHours;
      slots.add(TimeSlot(
        id: 'slot_$i',
        startHour: startHour,
        endHour: endHour,
        capacity: consultantCapacity,
      ));
    }
    return slots;
  }

  // ✅ Check ngày có làm việc không
  bool isWorkingDay(DateTime date) {
    final dayName = _getDayName(date.weekday);
    return workingDays.contains(dayName) && !isHoliday(date);
  }

  bool isHoliday(DateTime date) {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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