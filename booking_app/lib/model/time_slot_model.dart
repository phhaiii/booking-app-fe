class TimeSlot {
  final int startHour;
  final int endHour;
  final String label;
  final int index; // Index của time slot (0-based)
  bool isAvailable;

  TimeSlot({
    required this.startHour,
    required this.endHour,
    required this.label,
    required this.index,
    this.isAvailable = true,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeSlot &&
        other.startHour == startHour &&
        other.endHour == endHour &&
        other.index == index;
  }

  @override
  int get hashCode => startHour.hashCode ^ endHour.hashCode ^ index.hashCode;

  @override
  String toString() => label;
}
