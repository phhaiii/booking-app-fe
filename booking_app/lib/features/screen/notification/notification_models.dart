import 'package:booking_app/utils/constants/enums.dart';


// Models
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  bool isRead;
  final NotificationType type;
  final String? avatarUrl;
  final ChatUser? chatUser;
  final String? appointmentId;
  final AppointmentStatus? status;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.type,
    this.avatarUrl,
    this.chatUser,
    this.appointmentId,
    this.status,
  });
}

// ChatUser class
class ChatUser {
  final String id;
  final String firstName;
  final String? lastName;
  final String? imageUrl;

  const ChatUser({
    required this.id,
    required this.firstName,
    this.lastName,
    this.imageUrl,
  });
}