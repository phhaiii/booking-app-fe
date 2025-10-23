import 'package:booking_app/features/screen/list/budget_screen.dart';
import 'package:booking_app/features/screen/list/calendar_screen.dart';
import 'package:booking_app/features/screen/list/clothing_screen.dart';
import 'package:booking_app/features/screen/list/photography_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/sizes.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Lập kế hoạch cưới',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: WColors.primary,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _buildListItems().length,
        itemBuilder: (context, index) {
          final item = _buildListItems()[index];
          return _buildPlanningCard(item);
        },
      ),
    );
  }

  List<PlanningItemData> _buildListItems() {
    return [
      PlanningItemData(
        icon: Iconsax.calendar,
        title: 'Đặt lịch hẹn',
        subtitle: 'Lên lịch các sự kiện cưới và cuộc hẹn',
        color: Colors.blue,
        onTap: () => Get.to(() => const CalendarScreen()),
      ),
      PlanningItemData(
        icon: Iconsax.chart,
        title: 'Dự toán ngân sách',
        subtitle: 'Theo dõi chi phí và ngân sách đám cưới',
        color: Colors.green,
        onTap: () => Get.to(() => const BudgetScreen()),
      ),
      PlanningItemData(
        icon: Iconsax.shopping_bag,
        title: 'Trang phục',
        subtitle: 'Váy cưới, áo dài và phụ kiện',
        color: Colors.purple,
        onTap: () => Get.to(() => const ClothingScreen()),
      ),
      PlanningItemData(
        icon: Iconsax.camera,
        title: 'Gói chụp ảnh',
        subtitle: 'Chọn photographer và gói chụp ảnh cưới',
        color: Colors.orange,
        onTap: () => Get.to(() => const PhotographyScreen()),
      ),
    ];
  }

  Widget _buildPlanningCard(PlanningItemData item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Colors.white,
                item.color.withOpacity(0.05),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: item.color.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Iconsax.arrow_right_3,
                  color: item.color,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlanningItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  PlanningItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}
