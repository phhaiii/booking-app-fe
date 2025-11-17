import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/features/controller/booking_controller.dart';
import 'package:booking_app/formatter/booking_setting.dart';

class BookingTimeSlotsWidget extends StatelessWidget {
  final BookingController controller;
  final DateTime selectedDate;

  const BookingTimeSlotsWidget({
    super.key,
    required this.controller,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final slots = controller.getTimeSlotsForDate(selectedDate);
      final occupancy = controller.getSlotOccupancy(selectedDate);

      if (slots.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(Iconsax.calendar_remove,
                  size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                'Ngày này không làm việc',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header với tổng quan
            _buildHeader(occupancy),
            const Divider(height: 1),

            // Danh sách time slots
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: slots.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final slot = slots[index];
                return _buildTimeSlotCard(slot);
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(Map<String, dynamic> occupancy) {
    final bookedCount = occupancy['bookedCount'] as int;
    final totalCapacity = occupancy['totalCapacity'] as int;
    final occupancyRate = occupancy['occupancyRate'] as double;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.clock, color: WColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Khung giờ tư vấn',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: WColors.primary,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getOccupancyColor(occupancyRate).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(occupancyRate * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getOccupancyColor(occupancyRate),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(
                'Đã đặt',
                '$bookedCount/$totalCapacity',
                Iconsax.tick_circle,
                Colors.green,
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                'Còn trống',
                '${totalCapacity - bookedCount}',
                Iconsax.calendar_tick,
                Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: color.withOpacity(0.7),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotCard(TimeSlot slot) {
    final isAvailable = slot.isAvailable;
    final occupancyRate = slot.occupancyRate;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.white : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAvailable ? Colors.grey.shade300 : Colors.red.shade200,
        ),
      ),
      child: Row(
        children: [
          // Time range
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isAvailable
                  ? WColors.primary.withOpacity(0.1)
                  : Colors.red.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(
                  Iconsax.clock,
                  color: isAvailable ? WColors.primary : Colors.red,
                  size: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  slot.timeRange,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isAvailable ? WColors.primary : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isAvailable ? Iconsax.user_tick : Iconsax.close_circle,
                      size: 16,
                      color: isAvailable ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${slot.bookedCount}/${slot.capacity} slots',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isAvailable ? Colors.black87 : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: occupancyRate,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getOccupancyColor(occupancyRate),
                  ),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isAvailable
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isAvailable ? 'Còn chỗ' : 'Đầy',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isAvailable ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getOccupancyColor(double rate) {
    if (rate >= 1.0) return Colors.red;
    if (rate >= 0.8) return Colors.orange;
    if (rate >= 0.5) return Colors.amber;
    return Colors.green;
  }
}