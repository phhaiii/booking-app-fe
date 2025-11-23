import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/response/booking_response.dart';
import 'package:booking_app/utils/constants/colors.dart';
import '../helpers/booking_helper.dart';

class BookingDetailDialog {
  static void show(
    BuildContext context, {
    required BookingResponse booking,
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
                      if (booking.isRejected &&
                          booking.rejectionReason != null) ...[
                        const SizedBox(height: 16),
                        _buildRejectionInfo(booking),
                      ],
                      if (booking.isCancelled &&
                          booking.cancellationReason != null) ...[
                        const SizedBox(height: 16),
                        _buildCancellationInfo(booking),
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

  static Widget _buildHeader(BookingResponse booking) {
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

  static Widget _buildCustomerInfo(BookingResponse booking) {
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
        if (booking.customerEmail != null && booking.customerEmail!.isNotEmpty)
          _DetailItem(
            label: 'Email',
            value: booking.customerEmail!,
            icon: Iconsax.sms,
          ),
      ],
    );
  }

  static Widget _buildServiceInfo(BookingResponse booking) {
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
        if (booking.numberOfGuests > 0)
          _DetailItem(
            label: 'Số khách',
            value: '${booking.numberOfGuests} người',
            icon: Iconsax.people,
          ),
        if (booking.specialRequests != null && booking.specialRequests!.isNotEmpty)
          _DetailItem(
            label: 'Yêu cầu đặc biệt',
            value: '${booking.specialRequests}',
            icon: Iconsax.message_text,
          ),
      ],
    );
  }

  static Widget _buildRejectionInfo(BookingResponse booking) {
    return _DetailSection(
      title: 'Thông tin từ chối',
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withOpacity(0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Iconsax.info_circle, size: 20, color: Colors.red.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lý do từ chối:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking.rejectionReason ?? 'Không có lý do cụ thể',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildCancellationInfo(BookingResponse booking) {
    return _DetailSection(
      title: 'Thông tin hủy',
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Iconsax.info_circle, size: 20, color: Colors.grey.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lý do hủy:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking.cancellationReason ?? 'Không có lý do cụ thể',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildActions(BookingResponse booking) {
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
