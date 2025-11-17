import 'package:booking_app/model/venue_model.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class DashboardCard extends StatelessWidget {
  final VenueModel venue;
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
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Title
            Text(
              venue.name,
              style: txtTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: WColors.primary,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: WSizes.spaceBtwItems),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildVenueImage(),
            ),
            const SizedBox(height: WSizes.spaceBtwItems),

            // ✅ Location
            Row(
              children: [
                const Icon(Iconsax.location, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    venue.address,
                    style: txtTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: WSizes.spaceBtwItems / 2),

            // ✅ Capacity
            Row(
              children: [
                const Icon(Iconsax.people, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Sức chứa: ${venue.capacity} khách',
                  style: txtTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: WSizes.spaceBtwItems / 2),

            // ✅ Style (nếu có)
            if (venue.style != null && venue.style!.isNotEmpty)
              Row(
                children: [
                  const Icon(Iconsax.magic_star, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    venue.style!,
                    style: txtTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

            if (venue.style != null && venue.style!.isNotEmpty)
              const SizedBox(height: WSizes.spaceBtwItems / 2),

            // ✅ Price - SỬA: Dùng venue.price
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
                    text: ' / buổi',
                    style: txtTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: WSizes.spaceBtwItems),

            // ✅ Amenities - SỬA: Dùng venue.amenities
            if (venue.amenities.isNotEmpty)
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: venue.amenities.take(3).map((amenity) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: WColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: WColors.primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      amenity,
                      style: txtTheme.bodySmall?.copyWith(
                        color: WColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),

            // Show "more amenities" indicator
            if (venue.amenities.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '+${venue.amenities.length - 3} tiện ích khác',
                  style: txtTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

            const SizedBox(height: WSizes.spaceBtwItems),

            // ✅ Action Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // View More Button
                ElevatedButton.icon(
                  onPressed: onCardPressed,
                  icon: const Icon(Iconsax.eye, size: 18),
                  label: const Text(
                    'Xem chi tiết',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
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

  // ✅ Helper: Build venue image
  Widget _buildVenueImage() {
    // Ưu tiên thumbnailImage, nếu không có thì dùng imageUrls[0]
    final imageUrl = venue.thumbnailImage ??
        (venue.imageUrls.isNotEmpty ? venue.imageUrls.first : null);

    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildImagePlaceholder();
    }

    // Tạo full URL nếu là relative path
    final fullImageUrl = imageUrl.startsWith('http')
        ? imageUrl
        : 'http://10.0.2.2:8089$imageUrl';

    return Image.network(
      fullImageUrl,
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print('❌ Error loading image: $error');
        return _buildImagePlaceholder();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              color: WColors.primary,
            ),
          ),
        );
      },
    );
  }

  // ✅ Helper: Build image placeholder
  Widget _buildImagePlaceholder() {
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
            'Không có hình ảnh',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Helper: Format price
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
