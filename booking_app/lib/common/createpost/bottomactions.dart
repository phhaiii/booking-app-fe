import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/features/controller/createpost_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class BottomActions extends StatelessWidget {
  final CreatePostController controller;

  const BottomActions({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Publish Button
            Expanded(
              flex: 2,
              child: Obx(() => ElevatedButton.icon(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.publishPost,
                    icon: controller.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Iconsax.send_1, size: 20),
                    label: Text(
                      controller.isLoading.value ? 'Đang xử lý...' : 'Xuất bản',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
