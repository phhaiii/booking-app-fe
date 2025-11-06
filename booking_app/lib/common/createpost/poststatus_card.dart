import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/features/controller/createpost_controller.dart';
import 'package:iconsax/iconsax.dart';

class PostStatusCard extends StatelessWidget {
  final CreatePostController controller;

  const PostStatusCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: WColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Iconsax.document_text,
                color: WColors.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tạo bài viết mới',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: WColors.primary,
                        fontSize: 16,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Chia sẻ thông tin về dịch vụ cưới của bạn',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
