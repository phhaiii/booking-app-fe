import 'package:booking_app/models/venuedetail_response.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class DashboardCard extends StatelessWidget {
  final VenueDetailResponse venue;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onCardPressed;

  const DashboardCard({
    super.key,
    required this.venue,
    this.onFavoritePressed,
    this.onCardPressed,
  });

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onCardPressed,
      child: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              venue.title,
              style: txtTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: WColors.primary,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: WSizes.spaceBtwItems),

            // Image with better error handling
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                venue.imagePath,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ảnh không khả dụng',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: WSizes.spaceBtwItems),

            // Location & Rating
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Iconsax.location,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          venue.location,
                          style: txtTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.star1, size: 14, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        venue.rating.toStringAsFixed(1),
                        style: txtTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: WSizes.spaceBtwItems / 2),

            // Price
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: _formatPrice(venue.price),
                    style: txtTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: WColors.primary,
                    ),
                  ),
                  TextSpan(
                    text: ' / tiệc',
                    style: txtTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: WSizes.spaceBtwItems / 2),

            // Subtitle
            Text(
              venue.subtitle,
              style: txtTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade700,
                height: 1.4,
              ),
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: WSizes.spaceBtwItems),

            // Amenities preview
            if (venue.amenities.isNotEmpty)
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: venue.amenities.take(3).map((amenity) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: WColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      amenity,
                      style: txtTheme.bodySmall?.copyWith(
                        color: WColors.primary,
                        fontSize: 11,
                      ),
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: WSizes.spaceBtwItems),

            // Review count
            if (venue.reviewCount > 0)
              Padding(
                padding:
                    const EdgeInsets.only(bottom: WSizes.spaceBtwItems / 2),
                child: Text(
                  '${venue.reviewCount} đánh giá',
                  style: txtTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ),

            // Action Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Favorite Button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: venue.isFavorite
                        ? Colors.red.shade50
                        : Colors.grey.shade100,
                  ),
                  child: IconButton(
                    onPressed: onFavoritePressed,
                    icon: Icon(
                      venue.isFavorite ? Iconsax.heart5 : Iconsax.heart,
                      color: venue.isFavorite ? Colors.red : Colors.grey,
                      size: 24,
                    ),
                  ),
                ),

                // View More Button
                TextButton.icon(
                  onPressed: onCardPressed,
                  icon: const Icon(Iconsax.eye, size: 18),
                  label: const Text(
                    'Xem thêm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: WColors.primary.withOpacity(0.1),
                    foregroundColor: WColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to format price
  String _formatPrice(double price) {
    if (price >= 1000000) {
      double millions = price / 1000000;
      if (millions == millions.toInt()) {
        return '${millions.toInt()} triệu';
      } else {
        return '${millions.toStringAsFixed(1)} triệu';
      }
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    }
    return '${price.toStringAsFixed(0)}đ';
  }
}
