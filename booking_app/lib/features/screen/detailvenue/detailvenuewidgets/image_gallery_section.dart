import 'package:booking_app/features/controller/detailvenue_controller.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageGallerySection extends StatelessWidget {
  final List<String> images;
  final DetailVenueController controller;

  const ImageGallerySection({
    super.key,
    required this.images,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Container(
        height: 300,
        color: Colors.grey.shade300,
        child: Center(
          child: Icon(Icons.image_not_supported,
              size: 80, color: Colors.grey.shade400),
        ),
      );
    }

    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            onPageChanged: controller.updateImageIndex,
            itemBuilder: (context, index) {
              return Image.network(
                controller.getImageUrl(images[index]),
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: CircularProgressIndicator(color: WColors.primary),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported,
                        size: 50, color: Colors.grey),
                  );
                },
              );
            },
          ),
          if (images.length > 1) ...[
            // Image counter
            Positioned(
              bottom: 16,
              right: 16,
              child: Obx(() => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${controller.selectedImageIndex.value + 1}/${images.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )),
            ),
            // Dots indicator
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: images.asMap().entries.map((entry) {
                      return Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              controller.selectedImageIndex.value == entry.key
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                        ),
                      );
                    }).toList(),
                  )),
            ),
          ],
        ],
      ),
    );
  }
}
