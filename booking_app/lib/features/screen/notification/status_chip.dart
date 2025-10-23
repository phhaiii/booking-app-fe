import 'package:booking_app/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/notification_utils.dart';

class StatusChip extends StatelessWidget {
  final AppointmentStatus status;

  const StatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: NotificationUtils.getAppointmentStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: NotificationUtils.getAppointmentStatusColor(status).withOpacity(0.3),
        ),
      ),
      child: Text(
        NotificationUtils.getAppointmentStatusText(status),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: NotificationUtils.getAppointmentStatusColor(status),
        ),
      ),
    );
  }
}