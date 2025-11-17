import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/features/controller/createpost_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class ImagesSection extends StatelessWidget {
  final CreatePostController controller;

  const ImagesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Hình ảnh',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton.icon(
              onPressed: controller.pickImages,
              icon: const Icon(Iconsax.gallery_add, size: 16),
              label: const Text('Thêm ảnh'),
            ),
          ],
        ),
        const SizedBox(height: WSizes.spaceBtwItems),
        Obx(() {
          final hasExistingImages = controller.existingImageUrls.isNotEmpty;
          final hasNewImages = controller.selectedImages.isNotEmpty;
          final hasAnyImages = hasExistingImages || hasNewImages;

          return hasAnyImages ? _buildAllImages() : _buildImagePlaceholder();
        }),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return GestureDetector(
      onTap: controller.pickImages,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.gallery_add, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text('Thêm hình ảnh',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
            Text('Nhấn để chọn ảnh từ thư viện',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildAllImages() {
    // Get first image (either existing or new)
    final hasExisting = controller.existingImageUrls.isNotEmpty;

    return Column(
      children: [
        // Main image
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: hasExisting
                ? Image.network(
                    controller.existingImageUrls[0],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.error),
                    ),
                  )
                : Image.file(controller.selectedImages[0], fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 8),

        // Thumbnails - show both existing and new images
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Existing images
              ...controller.existingImageUrls.asMap().entries.map((entry) {
                final index = entry.key;
                final url = entry.value;
                return _buildExistingImageThumbnail(url, index);
              }),
              // New images
              ...controller.selectedImages.asMap().entries.map((entry) {
                final index = entry.key;
                final file = entry.value;
                return _buildNewImageThumbnail(file, index);
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExistingImageThumbnail(String url, int index) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              width: 80,
              height: 80,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.error, size: 20),
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => controller.removeExistingImage(index),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 12),
              ),
            ),
          ),
          // Label for existing images
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Cũ',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewImageThumbnail(dynamic file, int index) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              file,
              fit: BoxFit.cover,
              width: 80,
              height: 80,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => controller.removeImage(index),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 12),
              ),
            ),
          ),
          // Label for new images
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Mới',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
