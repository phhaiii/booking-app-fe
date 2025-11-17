import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BookingTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final List<String> tabs;

  const BookingTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _TabButton(
              index: 0,
              title: 'Chờ xử lý',
              icon: Iconsax.clock,
              color: Colors.orange,
              isSelected: selectedIndex == 0,
              onTap: () => onTabSelected(0),
            ),
            Container(width: 1, height: 40, color: Colors.grey.shade200),
            _TabButton(
              index: 1,
              title: 'Đã xác nhận',
              icon: Iconsax.tick_circle,
              color: Colors.green,
              isSelected: selectedIndex == 1,
              onTap: () => onTabSelected(1),
            ),
            Container(width: 1, height: 40, color: Colors.grey.shade200),
            _TabButton(
              index: 2,
              title: 'Đã từ chối',
              icon: Iconsax.close_circle,
              color: Colors.red,
              isSelected: selectedIndex == 2,
              onTap: () => onTabSelected(2),
            ),
            Container(width: 1, height: 40, color: Colors.grey.shade200),
            _TabButton(
              index: 3,
              title: 'Đã hủy',
              icon: Iconsax.slash,
              color: Colors.grey.shade600,
              isSelected: selectedIndex == 3,
              onTap: () => onTabSelected(3),
            ),
            Container(width: 1, height: 40, color: Colors.grey.shade200),
            _TabButton(
              index: 4,
              title: 'Khung giờ',
              icon: Iconsax.calendar,
              color: Colors.blue,
              isSelected: selectedIndex == 4,
              onTap: () => onTabSelected(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final int index;
  final String title;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.index,
    required this.title,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? color : Colors.grey.shade400,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
