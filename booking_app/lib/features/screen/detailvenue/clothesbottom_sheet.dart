import 'package:booking_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ClothesBottomSheet extends StatelessWidget {
  final dynamic venue;

  const ClothesBottomSheet({super.key, required this.venue});

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
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Iconsax.user_octagon,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trang phục cưới',
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

          // Clothes categories
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildClothesCategory(
                  'TRANG PHỤC CÔ DÂU',
                  Colors.pink,
                  [
                    _ClothesItem('Váy cưới Princess', 'Váy bồng công chúa, chất liệu ren cao cấp', '2.500.000đ/ngày'),
                    _ClothesItem('Váy cưới Mermaid', 'Váy đuôi cá ôm dáng, tôn lên vẻ quyến rũ', '3.200.000đ/ngày'),
                    _ClothesItem('Váy cưới A-line', 'Váy dáng chữ A thanh lịch, phù hợp mọi vóc dáng', '2.800.000đ/ngày'),
                    _ClothesItem('Áo dài cưới', 'Áo dài truyền thống với họa tiết thêu tay', '1.800.000đ/ngày'),
                    _ClothesItem('Trang phục cổ trang', 'Phượng bào hoàng gia, thêu rồng phượng', '3.500.000đ/ngày'),
                  ],
                ),
                _buildClothesCategory(
                  'TRANG PHỤC CHÚ RỂ',
                  Colors.blue,
                  [
                    _ClothesItem('Vest đen classic', 'Vest đen lịch lãm, chất liệu wool cao cấp', '1.200.000đ/ngày'),
                    _ClothesItem('Vest xám navy', 'Vest xám navy hiện đại, phù hợp buổi sáng', '1.400.000đ/ngày'),
                    _ClothesItem('Smoking đen', 'Tuxedo đen sang trọng cho tiệc tối', '1.800.000đ/ngày'),
                    _ClothesItem('Áo dài nam', 'Áo dài nam truyền thống với thiết kế hiện đại', '1.000.000đ/ngày'),
                    _ClothesItem('Trang phục cổ trang', 'Long bào hoàng gia, thêu rồng vàng', '2.500.000đ/ngày'),
                  ],
                ),
                _buildClothesCategory(
                  'PHỤ KIỆN',
                  Colors.purple,
                  [
                    _ClothesItem('Giày cưới cô dâu', 'Giày cao gót 7cm, đính đá pha lê', '800.000đ/ngày'),
                    _ClothesItem('Giày tây chú rể', 'Giày tây da thật, màu đen bóng', '500.000đ/ngày'),
                    _ClothesItem('Vương miện cô dâu', 'Vương miện đính đá quý, thiết kế hoàng gia', '1.200.000đ/ngày'),
                    _ClothesItem('Nhẫn cưới', 'Nhẫn vàng 18k, có thể khắc tên', '2.000.000đ/cặp'),
                    _ClothesItem('Hoa cầm tay', 'Hoa tươi theo yêu cầu, thiết kế độc đáo', '600.000đ/bó'),
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
                    'Đã lưu trang phục vào danh sách quan tâm',
                    backgroundColor: Colors.orange.withOpacity(0.1),
                    colorText: Colors.orange,
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
                  'Thuê trang phục',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClothesCategory(String title, Color color, List<_ClothesItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
        ),
        ...items.map((item) => _buildClothesItem(item.name, item.description, item.price)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildClothesItem(String name, String description, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: WColors.primary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClothesItem {
  final String name;
  final String description;
  final String price;

  _ClothesItem(this.name, this.description, this.price);
}