import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/features/controller/createpost_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class DetailsSection extends StatelessWidget {
  final CreatePostController controller;

  const DetailsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chi tiết dịch vụ',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: WSizes.spaceBtwItems),
        
        // Location
        TextFormField(
          controller: controller.locationController,
          decoration: InputDecoration(
            labelText: 'Địa điểm *',
            hintText: 'Nhập địa chỉ cụ thể...',
            prefixIcon: const Icon(Iconsax.location),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: WColors.primary),
            ),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Vui lòng nhập địa điểm' : null,
        ),
        const SizedBox(height: WSizes.spaceBtwItems),
        
        Row(
          children: [
            // Price
            Expanded(
              child: TextFormField(
                controller: controller.priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Giá (VNĐ) *',
                  hintText: '0',
                  prefixIcon: const Icon(Iconsax.money),
                  suffixText: 'VNĐ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: WColors.primary),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Vui lòng nhập giá';
                  if (double.tryParse(value!) == null) return 'Giá không hợp lệ';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            
            // Capacity
            Expanded(
              child: TextFormField(
                controller: controller.capacityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Sức chứa *',
                  hintText: '0',
                  prefixIcon: const Icon(Iconsax.people),
                  suffixText: 'khách',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: WColors.primary),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Vui lòng nhập sức chứa';
                  if (int.tryParse(value!) == null) return 'Số không hợp lệ';
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: WSizes.spaceBtwItems),
        
        // Style Selection
        Obx(() => DropdownButtonFormField<String>(
          value: controller.selectedStyle.value,
          decoration: InputDecoration(
            labelText: 'Phong cách *',
            prefixIcon: const Icon(Iconsax.color_swatch),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: WColors.primary),
            ),
          ),
          items: controller.styles.map((style) {
            return DropdownMenuItem(
              value: style,
              child: Text(style),
            );
          }).toList(),
          onChanged: (value) => controller.selectedStyle.value = value!,
        )),
      ],
    );
  }
}