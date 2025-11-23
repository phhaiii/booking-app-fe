import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/formatter/date_formatter.dart';
import 'package:booking_app/features/controller/userbooking_controller.dart';

class BookingConfirmDialog {
  static void show(UserBookingController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Xác nhận đặt lịch',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: WColors.primary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConfirmRow(
              'Địa điểm',
              controller.selectedVenue.value?.title ?? 'Chưa chọn',
            ),
            _buildConfirmRow(
              'Ngày & giờ',
              DateFormatter.formatDateTime(controller.selectedDate.value),
            ),
            _buildConfirmRow(
              'Số khách',
              '${controller.guestCount.value} người',
            ),
            _buildConfirmRow(
              'Menu',
              controller.selectedMenu.value?.name ?? 'Không chọn',
            ),
            if (controller.specialRequests.value.isNotEmpty)
              _buildConfirmRow(
                'Yêu cầu',
                controller.specialRequests.value,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Hủy',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.createBooking();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: WColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  static Widget _buildConfirmRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
