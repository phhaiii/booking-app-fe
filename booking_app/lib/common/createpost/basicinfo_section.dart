import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/features/controller/createpost_controller.dart';
import 'package:iconsax/iconsax.dart';

class BasicInfoSection extends StatelessWidget {
  final CreatePostController controller;

  const BasicInfoSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin cơ bản',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: WSizes.spaceBtwItems),

        // Title
        TextFormField(
          controller: controller.titleController,
          decoration: const InputDecoration(
            labelText: 'Tiêu đề bài viết *',
            hintText: 'VD: Nhà hàng tiệc cưới sang trọng...',
            prefixIcon: Icon(Iconsax.edit),
            border: OutlineInputBorder(),
          ),
          maxLength: 100,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Vui lòng nhập tiêu đề';
            if (value!.length < 10)
              return 'Tiêu đề quá ngắn (tối thiểu 10 ký tự)';
            return null;
          },
        ),
        const SizedBox(height: WSizes.spaceBtwInputFields),

        // Description
        TextFormField(
          controller: controller.descriptionController,
          decoration: const InputDecoration(
            labelText: 'Mô tả ngắn *',
            hintText: 'Mô tả ngắn gọn về dịch vụ của bạn...',
            prefixIcon: Icon(Iconsax.document_text_1),
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          maxLength: 200,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Vui lòng nhập mô tả';
            if (value!.length < 20)
              return 'Mô tả quá ngắn (tối thiểu 20 ký tự)';
            return null;
          },
        ),
        const SizedBox(height: WSizes.spaceBtwInputFields),
      ],
    );
  }
}
