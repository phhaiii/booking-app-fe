import 'package:booking_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class MenuBottomSheet extends StatelessWidget {
  final dynamic venue;

  const MenuBottomSheet({super.key, required this.venue});

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
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Iconsax.receipt_edit,
                    color: Colors.green,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menu đồ ăn',
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

          // Menu List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildMenuCategory(
                  'KHAI VỊ',
                  [
                    _MenuItem('Salad Nga', 'Salad truyền thống với cà rốt, khoai tây', '120.000đ'),
                    _MenuItem('Chả cá Lã Vọng', 'Món đặc sản Hà Nội với thì là', '180.000đ'),
                    _MenuItem('Nem rán', 'Nem rán giòn với nhân thịt tôm', '150.000đ'),
                    _MenuItem('Bánh cuốn', 'Bánh cuốn nóng với chả lụa', '100.000đ'),
                  ],
                ),
                _buildMenuCategory(
                  'MÓN CHÍNH',
                  [
                    _MenuItem('Gà nướng mật ong', 'Gà ta nướng với mật ong đặc biệt', '450.000đ'),
                    _MenuItem('Cá hấp xì dầu', 'Cá tươi hấp với nước tương đậm đà', '380.000đ'),
                    _MenuItem('Thịt nướng BBQ', 'Thịt heo nướng kiểu Hàn Quốc', '420.000đ'),
                    _MenuItem('Tôm rang me', 'Tôm tươi rang với me chua ngọt', '520.000đ'),
                    _MenuItem('Lẩu Thái', 'Lẩu chua cay với hải sản tươi sống', '650.000đ'),
                  ],
                ),
                _buildMenuCategory(
                  'TRÁNG MIỆNG',
                  [
                    _MenuItem('Chè đậu đỏ', 'Chè đậu đỏ truyền thống', '60.000đ'),
                    _MenuItem('Kem tươi', 'Kem vanilla với topping tự chọn', '80.000đ'),
                    _MenuItem('Bánh flan', 'Bánh flan caramen mềm mịn', '70.000đ'),
                    _MenuItem('Chè thái', 'Chè thái với dừa tươi', '65.000đ'),
                  ],
                ),
                _buildMenuCategory(
                  'ĐỒ UỐNG',
                  [
                    _MenuItem('Nước ngọt', 'Coca, Pepsi, Sprite, 7Up', '25.000đ'),
                    _MenuItem('Bia Tiger/Heineken', 'Bia tươi mát lạnh', '35.000đ'),
                    _MenuItem('Rượu vang đỏ', 'Rượu vang Pháp cao cấp', '850.000đ/chai'),
                    _MenuItem('Trà đá', 'Trà đá truyền thống', '15.000đ'),
                    _MenuItem('Cà phê sữa đá', 'Cà phê phin Việt Nam', '30.000đ'),
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
                    'Đã lưu menu vào danh sách quan tâm',
                    backgroundColor: Colors.green.withOpacity(0.1),
                    colorText: Colors.green,
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
                  'Đặt menu này',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCategory(String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.green,
            ),
          ),
        ),
        ...items.map((item) => _buildMenuItem(item.name, item.description, item.price)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMenuItem(String name, String description, String price) {
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

class _MenuItem {
  final String name;
  final String description;
  final String price;

  _MenuItem(this.name, this.description, this.price);
}