import 'package:booking_app/features/screen/notification/notification_data.dart';
import 'package:booking_app/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/features/screen/chat/chat_ui.dart';
import 'package:booking_app/features/screen/chat/chat_screen.dart';
import 'package:booking_app/features/screen/notification/notification_models.dart';
import 'package:booking_app/features/screen/notification/notification_card.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Tất cả notifications trong 1 list duy nhất
  List<NotificationItem> allNotifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      // Gộp tất cả notifications lại và sắp xếp theo thời gian
      final messageNotifications = NotificationData.getMessageNotifications();
      final appointmentNotifications = NotificationData.getAppointmentNotifications();
      
      allNotifications = [...messageNotifications, ...appointmentNotifications];
      allNotifications.sort((a, b) => b.time.compareTo(a.time)); // Mới nhất trước
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Thông báo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: WColors.primary,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _markAllAsRead,
            icon: const Icon(Icons.done_all, color: Colors.white),
            tooltip: 'Đánh dấu tất cả đã đọc',
          ),
          IconButton(
            onPressed: _clearAllNotifications,
            icon: const Icon(Icons.clear_all, color: Colors.white),
            tooltip: 'Xóa tất cả',
          ),
        ],
      ),
      body: _buildNotificationList(),
    );
  }

  Widget _buildNotificationList() {
    if (allNotifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.notification_bing, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Không có thông báo',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Các thông báo mới sẽ xuất hiện ở đây',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshNotifications,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: allNotifications.length,
        itemBuilder: (context, index) {
          final notification = allNotifications[index];
          return NotificationCard(
            notification: notification,
            onTap: () => _onNotificationTap(notification),
          );
        },
      ),
    );
  }

  Future<void> _refreshNotifications() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));
    _loadNotifications();
    
    Get.snackbar(
      'Đã cập nhật',
      'Thông báo đã được làm mới',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _onNotificationTap(NotificationItem notification) {
    // Mark as read
    setState(() {
      notification.isRead = true;
    });

    // Navigate based on notification type
    if (notification.type == NotificationType.message) {
      _navigateToChat(notification);
    } else if (notification.type == NotificationType.appointment) {
      _navigateToAppointmentDetail(notification.appointmentId!);
    }
  }

  void _navigateToChat(NotificationItem notification) {
    try {
      if (notification.chatUser != null) {
        // Convert ChatUser to types.User
        final user = types.User(
          id: notification.chatUser!.id,
          firstName: notification.chatUser!.firstName,
          lastName: notification.chatUser!.lastName,
          imageUrl: notification.chatUser!.imageUrl,
        );
        Get.to(() => ChatScreen(user: user));
      } else {
        // Navigate to chat list if no specific user
        Get.to(() => const ChatUIScreen());
      }
    } catch (e) {
      // Fallback navigation
      Get.to(() => const ChatUIScreen());
      Get.snackbar(
        'Thông báo',
        'Chuyển đến danh sách tin nhắn',
        backgroundColor: WColors.primary,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _navigateToAppointmentDetail(String appointmentId) {
    // Get.to(() => AppointmentDetailScreen(appointmentId: appointmentId));
    
    // For now, show detailed info in a bottom sheet
    _showAppointmentDetails(appointmentId);
  }

  void _showAppointmentDetails(String appointmentId) {
    // Find the appointment notification
    final appointment = allNotifications.firstWhere(
      (notification) => notification.appointmentId == appointmentId,
      orElse: () => allNotifications.first,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            Text(
              'Chi tiết lịch hẹn',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Appointment ID
            _buildDetailRow('Mã lịch hẹn:', appointmentId),
            _buildDetailRow('Tiêu đề:', appointment.title),
            _buildDetailRow('Nội dung:', appointment.message),
            _buildDetailRow('Thời gian:', _formatDateTime(appointment.time)),
            _buildDetailRow('Trạng thái:', _getStatusText(appointment.status!)),
            
            const SizedBox(height: 20),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Đóng'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.snackbar(
                        'Thông báo',
                        'Chức năng đang được phát triển',
                        backgroundColor: WColors.primary,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Xem chi tiết'),
                  ),
                ),
              ],
            ),
            
            // Safe area padding
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getStatusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.confirmed:
        return 'Đã xác nhận';
      case AppointmentStatus.pending:
        return 'Chờ xác nhận';
      case AppointmentStatus.cancelled:
        return 'Đã hủy';
      case AppointmentStatus.completed:
        return 'Hoàn thành';
      case AppointmentStatus.rescheduled:
        return 'Đã đổi lịch';
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in allNotifications) {
        notification.isRead = true;
      }
    });
    
    Get.snackbar(
      'Thành công',
      'Đã đánh dấu tất cả thông báo là đã đọc',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa tất cả thông báo'),
        content: const Text('Bạn có chắc chắn muốn xóa tất cả thông báo? Hành động này không thể hoàn tác.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                allNotifications.clear();
              });
              Navigator.pop(context);
              Get.snackbar(
                'Thành công',
                'Đã xóa tất cả thông báo',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}