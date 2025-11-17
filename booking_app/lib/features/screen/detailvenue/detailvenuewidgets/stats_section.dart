import 'package:booking_app/features/controller/detailvenue_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class StatsSection extends StatelessWidget {
  final DetailVenueController controller;

  const StatsSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final venue = controller.venue.value;
      final avgRating = controller.averageRating;
      final reviewCount = controller.totalReviewCount;

      // 🔍 DEBUG: In ra giá trị để kiểm tra
      print('═══ STATS SECTION DEBUG ═══');
      print('Venue rating: ${venue?.rating}');
      print('Venue reviewCount: ${venue?.reviewCount}');
      print('Venue commentCount: ${venue?.commentCount}');
      print('Controller averageRating: $avgRating');
      print('Controller totalReviewCount: $reviewCount');
      print('Backend averageRating: ${controller.backendAverageRating.value}');
      print('Backend totalComments: ${controller.backendTotalComments.value}');
      print('Loaded comments count: ${controller.comments.length}');
      print('═══════════════════════════');

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                icon: Iconsax.star1,
                label: avgRating > 0
                    ? avgRating.toStringAsFixed(1)
                    : (reviewCount > 0 ? '–' : '0.0'),
                sublabel: reviewCount > 0
                    ? '$reviewCount đánh giá'
                    : 'Chưa có đánh giá',
                color: Colors.orange,
              ),
            ),
            Container(width: 1, height: 40, color: Colors.grey.shade300),
            Expanded(
              child: _buildStatItem(
                icon: Iconsax.people,
                label: '${venue?.capacity ?? 0}',
                sublabel: 'Sức chứa',
                color: Colors.blue,
              ),
            ),
            Container(width: 1, height: 40, color: Colors.grey.shade300),
            Expanded(
              child: _buildStatItem(
                icon: Iconsax.money,
                label: _formatPrice(venue?.price ?? 0),
                sublabel: 'Giá/bàn',
                color: Colors.green,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String sublabel,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade900,
          ),
        ),
        Text(
          sublabel,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      double millions = price / 1000000;
      if (millions == millions.toInt()) {
        return '${millions.toInt()}tr';
      } else {
        return '${millions.toStringAsFixed(1)}tr';
      }
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}k';
    }
    return '${price.toStringAsFixed(0)}đ';
  }
}
