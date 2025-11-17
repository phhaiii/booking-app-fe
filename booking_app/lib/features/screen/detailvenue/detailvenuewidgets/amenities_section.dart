import 'package:booking_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AmenitiesSection extends StatelessWidget {
  final dynamic venue;

  const AmenitiesSection({
    super.key,
    required this.venue,
  });

  @override
  Widget build(BuildContext context) {
    final amenities = venue.amenities ?? [];

    if (amenities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tiện ích & Dịch vụ',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: amenities.map<Widget>((amenity) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: WColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: WColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getAmenityIcon(amenity),
                      size: 14,
                      color: WColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      amenity,
                      style: const TextStyle(
                        color: WColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'bãi đỗ xe':
      case 'bãi đỗ xe 200 chỗ':
      case 'valet parking':
      case 'parking':
        return Iconsax.car;
      case 'wifi miễn phí':
      case 'wifi':
        return Iconsax.wifi;
      case 'điều hòa':
      case 'air_conditioning':
        return Iconsax.wind_2;
      case 'âm thanh chuyên nghiệp':
      case 'âm thanh led 5d':
      case 'sound_system':
        return Iconsax.volume_high;
      case 'ánh sáng led':
      case 'led ceiling':
        return Iconsax.lamp_1;
      case 'phòng thay đồ':
      case 'phòng cô dâu vip':
        return Iconsax.home_1;
      case 'trang trí miễn phí':
      case 'trang trí luxury':
        return Iconsax.brush_1;
      case 'mc chuyên nghiệp':
        return Iconsax.microphone;
      case 'phục vụ rượu':
      case 'menu cao cấp':
        return Iconsax.cup;
      case 'stage':
        return Iconsax.courthouse;
      case 'projector':
        return Iconsax.video_square;
      default:
        return Iconsax.tick_circle;
    }
  }
}
