import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/features/controller/createpost_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class ContentSection extends StatelessWidget {
  final CreatePostController controller;

  const ContentSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Nội dung chi tiết',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            Obx(() => Text(
                  '${controller.contentLength.value}/1000',
                  style: TextStyle(
                    color: controller.contentLength.value > 1000
                        ? Colors.red
                        : Colors.grey.shade600,
                    fontSize: 12,
                  ),
                )),
          ],
        ),
        const SizedBox(height: WSizes.spaceBtwItems),

        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              TextFormField(
                controller: controller.contentController,
                maxLines: 8,
                maxLength: 1000,
                decoration: InputDecoration(
                  hintText: 'Viết nội dung chi tiết về dịch vụ của bạn...\n\n'
                      '• Mô tả chi tiết dịch vụ\n'
                      '• Quy trình thực hiện\n'
                      '• Ưu điểm nổi bật\n'
                      '• Chính sách và điều khoản',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  counterText: '',
                ),
                style: const TextStyle(fontSize: 16, height: 1.5),
                
              ),
            ],
          ),
        ),
        const SizedBox(height: WSizes.spaceBtwItems / 2),

        // Tips
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Iconsax.info_circle, color: Colors.blue.shade600, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mẹo viết nội dung hiệu quả:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '• Sử dụng ngôn ngữ dễ hiểu, thân thiện\n'
                      '• Nêu rõ ưu điểm và giá trị của dịch vụ\n'
                      '• Thêm thông tin liên hệ và chính sách',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
