import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/formatter/currency_formatter.dart';
import 'package:booking_app/features/controller/userbooking_controller.dart';

class VenueSelectorWidget extends StatelessWidget {
  final UserBookingController controller;

  const VenueSelectorWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.venues.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text('Đang tải danh sách địa điểm...'),
          ),
        );
      }

      return Column(
        children: controller.venues.map((venue) {
          final isSelected = controller.selectedVenue.value?.id == venue.id;

          String imageUrl = '';
          if (venue.images.isNotEmpty) {
            final imagePath = venue.images.first;
            print('🖼️ DEBUG Image path: "$imagePath"');

            if (imagePath.startsWith('http://') ||
                imagePath.startsWith('https://')) {
              imageUrl = imagePath;
            } else if (imagePath.startsWith('/uploads/')) {
              imageUrl = 'http://10.0.2.2:8089$imagePath';
            } else if (imagePath.startsWith('uploads/')) {
              imageUrl = 'http://10.0.2.2:8089/$imagePath';
            } else {
              imageUrl = 'http://10.0.2.2:8089/uploads/$imagePath';
            }

            print('🖼️ Final URL: "$imageUrl"');
          }

          return GestureDetector(
            onTap: () => controller.selectVenue(venue),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _buildImagePlaceholder(),
                          )
                        : _buildImagePlaceholder(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          venue.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isSelected ? WColors.primary : Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Iconsax.location,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                venue.location,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Iconsax.star1,
                                size: 14, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              '${venue.rating.toStringAsFixed(1)} (${venue.reviewCount} reviews)',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              CurrencyFormatter.formatVND(venue.price),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: WColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Iconsax.tick_circle5,
                      color: WColors.primary,
                      size: 24,
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey.shade200,
      child: const Icon(Iconsax.building, size: 32, color: Colors.grey),
    );
  }
}
