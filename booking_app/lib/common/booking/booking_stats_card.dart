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
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // First row
          Row(
            children: [
              Expanded(
                child: Obx(() => _buildStatCard(
                      icon: Iconsax.clock,
                      label: 'Chờ duyệt',
                      value: controller.pendingBookings.length.toString(),
                      color: Colors.orange,
                    )),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(() => _buildStatCard(
                      icon: Iconsax.tick_circle,
                      label: 'Đã duyệt',
                      value: controller.confirmedBookings.length.toString(),
                      color: Colors.green,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Second row
          Row(
            children: [
              Expanded(
                child: Obx(() => _buildStatCard(
                      icon: Iconsax.close_circle,
                      label: 'Từ chối',
                      value: controller.rejectedBookings.length.toString(),
                      color: Colors.red,
                    )),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(() => _buildStatCard(
                      icon: Iconsax.slash,
                      label: 'Đã hủy',
                      value: controller.cancelledBookings.length.toString(),
                      color: Colors.grey.shade600,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
