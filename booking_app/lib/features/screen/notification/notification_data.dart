import 'package:booking_app/features/screen/notification/notification_models.dart';
import 'package:booking_app/utils/constants/enums.dart';

class NotificationData {
  static List<NotificationItem> getMessageNotifications() {
    return [
      NotificationItem(
        id: '1',
        title: 'Tin nhắn mới từ Trống Đồng Palace',
        message: 'Chúng tôi có gói ưu đãi đặc biệt cho tiệc cưới tháng này!',
        time: DateTime.now().subtract(const Duration(minutes: 15)),
        isRead: false,
        type: NotificationType.message,
        avatarUrl: 'assets/images/avatar1.png',
        chatUser: const ChatUser(
          id: '1',
          firstName: 'Trống Đồng',
          lastName: 'Palace',
          imageUrl: 'assets/images/avatar1.png',
        ),
      ),
      NotificationItem(
        id: '2',
        title: 'Long Vĩ Palace',
        message: 'Xin chào! Bạn có muốn xem thực đơn tiệc cưới không?',
        time: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
        type: NotificationType.message,
        avatarUrl: 'assets/images/avatar2.png',
        chatUser: const ChatUser(
          id: '2',
          firstName: 'Long Vĩ',
          lastName: 'Palace',
          imageUrl: 'assets/images/avatar2.png',
        ),
      ),
      NotificationItem(
        id: '3',
        title: 'The One Event Center',
        message: 'Cảm ơn bạn đã liên hệ! Chúng tôi sẽ gọi lại trong 30 phút.',
        time: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: false,
        type: NotificationType.message,
        avatarUrl: 'assets/images/avatar3.png',
        chatUser: const ChatUser(
          id: '3',
          firstName: 'The One',
          lastName: 'Event Center',
          imageUrl: 'assets/images/avatar3.png',
        ),
      ),
    ];
  }

  static List<NotificationItem> getAppointmentNotifications() {
    return [
      NotificationItem(
        id: '4',
        title: 'Lịch hẹn đã được xác nhận',
        message: 'Lịch hẹn #AP001 tại Trống Đồng Palace ngày 25/10/2024 lúc 14:00.',
        time: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
        type: NotificationType.appointment,
        appointmentId: 'AP001',
        status: AppointmentStatus.confirmed,
      ),
      NotificationItem(
        id: '5',
        title: 'Nhắc nhở lịch hẹn',
        message: 'Bạn có lịch hẹn tại Long Vĩ Palace vào ngày mai lúc 10:00.',
        time: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
        type: NotificationType.appointment,
        appointmentId: 'AP002',
        status: AppointmentStatus.pending,
      ),
      NotificationItem(
        id: '6',
        title: 'Lịch hẹn đã đổi',
        message: 'Lịch hẹn #AP001 đã được chuyển từ 14:00 sang 16:00 cùng ngày.',
        time: DateTime.now().subtract(const Duration(days: 1)),
        isRead: false,
        type: NotificationType.appointment,
        appointmentId: 'AP001',
        status: AppointmentStatus.rescheduled,
      ),
      NotificationItem(
        id: '7',
        title: 'Lịch hẹn hoàn thành',
        message: 'Buổi tư vấn #AP003 tại The One Event Center đã hoàn thành.',
        time: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
        type: NotificationType.appointment,
        appointmentId: 'AP003',
        status: AppointmentStatus.completed,
      ),
    ];
  }
}