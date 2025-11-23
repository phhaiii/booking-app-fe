import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/formatter/currency_formatter.dart';
import 'package:booking_app/features/controller/userbooking_controller.dart';

class MenuSelectorWidget extends StatelessWidget {
  final UserBookingController controller;

  const MenuSelectorWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.selectedVenue.value == null) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text('Vui lòng chọn địa điểm trước'),
          ),
        );
      }

      if (controller.menus.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text('Địa điểm này chưa có menu sẵn có'),
          ),
        );
      }

      return Column(
        children: [
          GestureDetector(
            onTap: () => controller.selectMenu(null),
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: controller.selectedMenu.value == null
                    ? WColors.primary.withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: controller.selectedMenu.value == null
                      ? WColors.primary
                      : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.close_circle, color: Colors.grey),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Không chọn menu (thương lượng sau)',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  if (controller.selectedMenu.value == null)
                    const Icon(Iconsax.tick_circle5, color: WColors.primary),
                ],
              ),
            ),
          ),
          ...controller.menus.map((menu) {
            final isSelected = controller.selectedMenu.value?.id == menu.id;

            return GestureDetector(
              onTap: () => controller.selectMenu(menu),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? WColors.primary.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? WColors.primary : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: WColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Iconsax.cake,
                        color: WColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            menu.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color:
                                  isSelected ? WColors.primary : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            CurrencyFormatter.formatPerGuest(menu.price),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: WColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Iconsax.tick_circle5,
                        color: WColors.primary,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      );
    });
  }
}
