import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/features/controller/createpost_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class AmenitiesSection extends StatelessWidget {
  final CreatePostController controller;

  const AmenitiesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Tiện ích & Dịch vụ',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            // ✅ Only wrap counter with Obx
            Obx(() => Text(
                  '${controller.selectedAmenities.length} đã chọn',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                )),
          ],
        ),
        const SizedBox(height: WSizes.spaceBtwItems / 2),

        Text(
          'Chọn các tiện ích và dịch vụ có sẵn',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: WSizes.spaceBtwItems),

        // ✅ Only wrap chips grid with Obx
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.availableAmenities.map((amenity) {
                final isSelected =
                    controller.selectedAmenities.contains(amenity);
                return FilterChip(
                  label: Text(amenity),
                  selected: isSelected,
                  onSelected: (selected) => controller.toggleAmenity(amenity),
                  backgroundColor: Colors.grey.shade100,
                  selectedColor: WColors.primary.withOpacity(0.2),
                  checkmarkColor: WColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? WColors.primary : Colors.grey.shade700,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected ? WColors.primary : Colors.grey.shade300,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }).toList(),
            )),

        const SizedBox(height: WSizes.spaceBtwItems),

        // Add custom amenity
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              const Icon(Iconsax.add_circle, color: WColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Thêm tiện ích khác...',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onFieldSubmitted: (value) {
                    if (value.trim().isNotEmpty &&
                        !controller.availableAmenities.contains(value.trim())) {
                      controller.availableAmenities.add(value.trim());
                      controller.selectedAmenities.add(value.trim());
                    }
                  },
                ),
              ),
              TextButton(
                onPressed: () => _showAddAmenityDialog(context),
                child: const Text('Thêm'),
              ),
            ],
          ),
        ),

        const SizedBox(height: WSizes.spaceBtwItems / 2),

        // ✅ Only wrap selected preview with Obx
        Obx(() => controller.selectedAmenities.isEmpty
            ? const SizedBox.shrink()
            : Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: WColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: WColors.primary.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Iconsax.tick_circle,
                            color: WColors.primary, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Tiện ích đã chọn:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: WColors.primary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: controller.selectedAmenities.map((amenity) {
                        return Chip(
                          label: Text(
                            amenity,
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: WColors.primary.withOpacity(0.1),
                          side: BorderSide(
                              color: WColors.primary.withOpacity(0.3)),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () => controller.toggleAmenity(amenity),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              )),
      ],
    );
  }

  void _showAddAmenityDialog(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Thêm tiện ích mới'),
        content: TextFormField(
          controller: textController,
          decoration: const InputDecoration(
            labelText: 'Tên tiện ích',
            hintText: 'Nhập tên tiện ích...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final amenity = textController.text.trim();
              if (amenity.isNotEmpty &&
                  !controller.availableAmenities.contains(amenity)) {
                controller.availableAmenities.add(amenity);
                controller.selectedAmenities.add(amenity);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: WColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }
}
