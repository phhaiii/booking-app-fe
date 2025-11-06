import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/features/controller/booking_controller.dart';

class BookingStatsCards extends StatelessWidget {
  final BookingController controller;

  const BookingStatsCards({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: Dùng GetBuilder thay vì Obx
    return GetBuilder<BookingController>(
      init: controller,
      builder: (ctrl) {
        final stats = ctrl.statistics.value;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Chờ xử lý',
                  count: (stats?.pendingBookings ??
                          ctrl.pendingBookings.length)
                      .toString(),
                  icon: Iconsax.clock,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Đã xác nhận',
                  count: (stats?.confirmedBookings ??
                          ctrl.confirmedBookings.length)
                      .toString(),
                  icon: Iconsax.tick_circle,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Đã từ chối',
                  count: (stats?.rejectedBookings ??
                          ctrl.rejectedBookings.length)
                      .toString(),
                  icon: Iconsax.close_circle,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}