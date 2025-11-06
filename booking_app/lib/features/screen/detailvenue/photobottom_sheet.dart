import 'package:booking_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PhotographyBottomSheet extends StatelessWidget {
  final dynamic venue;

  const PhotographyBottomSheet({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Iconsax.camera,
                    color: Colors.purple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gói chụp ảnh cưới',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: WColors.primary,
                            ),
                      ),
                      Text(
                        venue.title,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Photography packages
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildPackageCard(
                  'GÓI BASIC',
                  '5.500.000đ',
                  Colors.blue,
                  [
                    'Chụp ảnh cưới ngoại cảnh (4 tiếng)',
                    '50 ảnh đã chỉnh sửa',
                    '1 album ảnh 20x30cm (30 trang)',
                    'DVD ảnh gốc và đã edit',
                    'Trang phục cô dâu (1 bộ)',
                    'Makeup + làm tóc cô dâu',
                  ],
                ),
                _buildPackageCard(
                  'GÓI PREMIUM',
                  '9.800.000đ',
                  Colors.purple,
                  [
                    'Chụp ảnh cưới ngoại cảnh (6 tiếng)',
                    'Chụp ảnh studio (2 tiếng)',
                    '100 ảnh đã chỉnh sửa',
                    '1 album ảnh 25x35cm (50 trang)',
                    'DVD + USB ảnh gốc và đã edit',
                    'Trang phục cô dâu (3 bộ)',
                    'Trang phục chú rể (2 bộ)',
                    'Makeup + làm tóc cô dâu',
                    'Photo booth tại tiệc cưới',
                  ],
                ),
                _buildPackageCard(
                  'GÓI LUXURY',
                  '15.000.000đ',
                  Colors.amber,
                  [
                    'Chụp ảnh cưới ngoại cảnh (8 tiếng)',
                    'Chụp ảnh studio (4 tiếng)',
                    'Quay phim cưới cinematic',
                    '200 ảnh đã chỉnh sửa',
                    '2 album ảnh 30x40cm (80 trang)',
                    'DVD + USB + Cloud storage',
                    'Trang phục cô dâu cao cấp (5 bộ)',
                    'Trang phục chú rể (3 bộ)',
                    'Makeup + làm tóc chuyên nghiệp',
                    'Chụp ảnh + quay phim tại tiệc cưới',
                    'Flycam quay cảnh toàn cảnh',
                    'Same day edit video',
                  ],
                ),
              ],
            ),
          ),

          // Bottom button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    'Thành công',
                    'Đã lưu gói chụp ảnh vào danh sách quan tâm',
                    backgroundColor: Colors.purple.withOpacity(0.1),
                    colorText: Colors.purple,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: WColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Đặt gói chụp ảnh',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(String title, String price, Color color, List<String> features) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.05),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          // Features
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: features.map((feature) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Iconsax.tick_circle, color: color, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}