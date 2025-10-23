
import 'package:booking_app/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/features/screen/notification/notification_models.dart';
import 'package:booking_app/features/screen/notification/status_chip.dart';
import 'package:booking_app/utils/constants/notification_utils.dart';
class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: notification.isRead ? 1 : 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: notification.isRead ? Colors.white : Colors.blue.shade50,
            border: notification.isRead 
              ? null 
              : Border.all(color: WColors.primary.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar/Icon
              _buildNotificationIcon(),
              const SizedBox(width: 12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: notification.isRead 
                                ? FontWeight.w600 
                                : FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: WColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          NotificationUtils.formatTime(notification.time),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        if (notification.type == NotificationType.appointment)
                          StatusChip(status: notification.status!),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    if (notification.type == NotificationType.message) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: notification.avatarUrl != null 
          ? AssetImage(notification.avatarUrl!)
          : null,
        backgroundColor: WColors.primary.withOpacity(0.1),
        child: notification.avatarUrl == null
          ? Icon(Iconsax.message, color: WColors.primary)
          : null,
      );
    } else {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: NotificationUtils.getAppointmentStatusColor(notification.status!).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          NotificationUtils.getAppointmentStatusIcon(notification.status!),
          color: NotificationUtils.getAppointmentStatusColor(notification.status!),
          size: 24,
        ),
      );
    }
  }
}