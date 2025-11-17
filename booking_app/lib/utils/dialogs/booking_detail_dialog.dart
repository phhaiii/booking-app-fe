import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/response/booking_response.dart';
import 'package:booking_app/utils/constants/colors.dart';
import '../helpers/booking_helper.dart';

class BookingDetailDialog {
  static void show(
    BuildContext context, {
    required BookingRequestUI booking,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(booking),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCustomerInfo(booking),
                      const SizedBox(height: 16),
                      _buildServiceInfo(booking),
                      if (booking.message != null &&
                          booking.message!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildMessage(booking.message!),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildActions(booking),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildHeader(BookingRequestUI booking) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: WColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            BookingHelper.getServiceIcon(booking.serviceType),
            color: WColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Chi tiết đặt lịch',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: WColors.primary,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close),
          color: Colors.grey,
        ),
      ],
    );
  }

  static Widget _buildCustomerInfo(BookingRequestUI booking) {
    return _DetailSection(
      title: 'Thông tin khách hàng',
      children: [
        _DetailItem(
          label: 'Họ tên',
          value: booking.customerName,
          icon: Iconsax.user,
        ),
        _DetailItem(
          label: 'Điện thoại',
          value: booking.customerPhone,
          icon: Iconsax.call,
        ),
        _DetailItem(
          label: 'Email',
          value: booking.customerEmail,
          icon: Iconsax.sms,
        ),
      ],
    );
  }

  static Widget _buildServiceInfo(BookingRequestUI booking) {
    return _DetailSection(
      title: 'Thông tin dịch vụ',
      children: [
        _DetailItem(
          label: 'Tên dịch vụ',
          value: booking.serviceName,
          icon: Iconsax.note,
        ),
        _DetailItem(
          label: 'Loại dịch vụ',
          value: booking.serviceType,
          icon: Iconsax.category,
        ),
        _DetailItem(
          label: 'Ngày mong muốn',
          value: BookingHelper.formatDateTime(booking.requestedDate),
          icon: Iconsax.calendar,
        ),
        if (booking.numberOfGuests != null)
          _DetailItem(
            label: 'Số khách',
            value: '${booking.numberOfGuests} người',
            icon: Iconsax.people,
          ),
        if (booking.budget != null)
          _DetailItem(
            label: 'Ngân sách',
            value: '${BookingHelper.formatPrice(booking.budget!)} VNĐ',
            icon: Iconsax.money,
          ),
      ],
    );
  }

  static Widget _buildMessage(String message) {
    return _DetailSection(
      title: 'Lời nhắn',
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            message,
            style: const TextStyle(height: 1.5),
          ),
        ),
      ],
    );
  }

  static Widget _buildActions(BookingRequestUI booking) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Đóng'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () {
              Get.back();
              Get.snackbar(
                '📞 Đang gọi',
                'Gọi cho ${booking.customerName}...',
                backgroundColor: Colors.blue.withOpacity(0.1),
                colorText: Colors.blue,
              );
            },
            icon: const Icon(Iconsax.call),
            label: const Text('Gọi điện'),
            style: ElevatedButton.styleFrom(
              backgroundColor: WColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DetailSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: WColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade500),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}