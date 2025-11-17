import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/features/controller/createpost_controller.dart';
import 'package:booking_app/model/menu_model.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class MenuSection extends StatelessWidget {
  final CreatePostController controller;

  const MenuSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Set Menu Tiệc',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton.icon(
              onPressed: () => _showAddMenuDialog(context),
              icon: const Icon(Iconsax.add_circle, size: 16),
              label: const Text('Thêm Menu'),
              style: TextButton.styleFrom(foregroundColor: WColors.primary),
            ),
          ],
        ),
        const SizedBox(height: WSizes.spaceBtwItems / 2),

        Text(
          'Tạo các gói menu với giá và số người khác nhau',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: WSizes.spaceBtwItems),

        // Menu items list
        Obx(() => controller.menuItems.isEmpty
            ? _buildEmptyState()
            : _buildMenuList()),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Iconsax.note, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'Chưa có set menu nào',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Thêm các gói menu để khách hàng dễ dàng lựa chọn',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showAddMenuDialog(Get.context!),
            icon: const Icon(Iconsax.add),
            label: const Text('Thêm Set Menu'),
            style: ElevatedButton.styleFrom(
              backgroundColor: WColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.menuItems.length,
      itemBuilder: (context, index) {
        final menu = controller.menuItems[index];
        return _buildMenuCard(menu, index);
      },
    );
  }

  Widget _buildMenuCard(MenuModel menu, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: WColors.primary.withOpacity(0.05),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: WColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Iconsax.note_1,
                      color: WColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        menu.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: WColors.primary,
                        ),
                      ),
                      if (menu.description.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          menu.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Iconsax.edit, size: 18),
                  onPressed: () =>
                      _showEditMenuDialog(Get.context!, menu, index),
                  color: Colors.blue,
                ),
                IconButton(
                  icon: const Icon(Iconsax.trash, size: 18),
                  onPressed: () => _confirmDelete(index, menu.name),
                  color: Colors.red,
                ),
              ],
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price & Guests - UPDATED
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        icon: Iconsax.money,
                        label: 'Giá/bàn',
                        value: _formatPrice(menu.price),
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoChip(
                        icon: Iconsax.people,
                        label: 'Khách/bàn',
                        value: '${menu.guestsPerTable} người',
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Price per person (calculated)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Iconsax.wallet_money,
                              size: 16, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            'Giá/người:',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        _formatPrice(menu.pricePerPerson),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Dishes
                Text(
                  'Món ăn trong set (${menu.dishes.length} món):',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: menu.dishes.map((dish) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.purple.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        dish,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.purple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      double millions = price / 1000000;
      if (millions == millions.toInt()) {
        return '${millions.toInt()}tr';
      } else {
        return '${millions.toStringAsFixed(1)}tr';
      }
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}k';
    }
    return '${price.toStringAsFixed(0)}đ';
  }

  void _confirmDelete(int index, String menuName) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa set menu "$menuName"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.removeMenuItem(index);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _showAddMenuDialog(BuildContext context) {
    _showMenuDialog(context, null, null);
  }

  void _showEditMenuDialog(BuildContext context, MenuModel menu, int index) {
    _showMenuDialog(context, menu, index);
  }

  void _showMenuDialog(
      BuildContext context, MenuModel? existingMenu, int? index) {
    final nameController =
        TextEditingController(text: existingMenu?.name ?? '');
    final descController =
        TextEditingController(text: existingMenu?.description ?? '');
    final priceController =
        TextEditingController(text: existingMenu?.price.toString() ?? '');
    final guestsController = TextEditingController(
        text: existingMenu?.guestsPerTable.toString() ?? '10');
    final dishController = TextEditingController();
    final dishes = <String>[].obs;

    if (existingMenu != null) {
      dishes.addAll(existingMenu.dishes);
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: WColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Iconsax.note_1, color: WColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        existingMenu == null ? 'Thêm Set Menu' : 'Sửa Set Menu',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Menu Name
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Tên Set Menu *',
                    hintText: 'VD: Set Menu Tiêu Chuẩn',
                    prefixIcon: const Icon(Iconsax.note_1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: 'Mô tả (tùy chọn)',
                    hintText: 'Mô tả ngắn về set menu...',
                    prefixIcon: const Icon(Iconsax.document_text),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                // Price & Guests
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Giá/bàn *',
                          hintText: '15000000',
                          prefixIcon: const Icon(Iconsax.money),
                          suffixText: 'VNĐ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        // ✅ THÊM: Listen to changes để update calculated price
                        onChanged: (value) {
                          // Trigger rebuild for Obx
                          priceController.text = value;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: guestsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Số khách/bàn *',
                          hintText: '10',
                          prefixIcon: const Icon(Iconsax.people),
                          suffixText: 'người',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        // ✅ THÊM: Listen to changes
                        onChanged: (value) {
                          guestsController.text = value;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Show calculated price per person
                // ✅ FIX: Remove Obx, just show static calculated value
                Builder(
                  builder: (context) {
                    final price = double.tryParse(priceController.text) ?? 0;
                    final guests = int.tryParse(guestsController.text) ?? 10;
                    final pricePerPerson = guests > 0 ? price / guests : 0.0;

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Iconsax.calculator,
                                  size: 16, color: Colors.orange),
                              const SizedBox(width: 8),
                              Text(
                                'Giá ước tính/người:',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _formatPrice(pricePerPerson),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Dishes Section
                Row(
                  children: [
                    const Text(
                      'Món ăn trong set',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Obx(() => Text(
                          '${dishes.length} món',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: dishController,
                        decoration: InputDecoration(
                          hintText: 'Nhập tên món ăn...',
                          prefixIcon: const Icon(Iconsax.cup, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            dishes.add(value.trim());
                            dishController.clear();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (dishController.text.trim().isNotEmpty) {
                          dishes.add(dishController.text.trim());
                          dishController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: WColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(12),
                        minimumSize: const Size(50, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Icon(Iconsax.add),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Dishes list
                Obx(() {
                  if (dishes.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Center(
                        child: Text(
                          'Chưa có món ăn nào',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    );
                  }

                  return Container(
                    constraints: const BoxConstraints(maxHeight: 150),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: dishes.map((dish) {
                          return Chip(
                            label: Text(dish),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () => dishes.remove(dish),
                            backgroundColor: Colors.orange.withOpacity(0.1),
                            side: BorderSide(
                              color: Colors.orange.withOpacity(0.3),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Hủy'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate
                          if (nameController.text.trim().isEmpty) {
                            Get.snackbar('Lỗi', 'Vui lòng nhập tên set menu');
                            return;
                          }
                          if (priceController.text.trim().isEmpty) {
                            Get.snackbar('Lỗi', 'Vui lòng nhập giá');
                            return;
                          }
                          if (guestsController.text.trim().isEmpty) {
                            Get.snackbar('Lỗi', 'Vui lòng nhập số khách');
                            return;
                          }
                          if (dishes.isEmpty) {
                            Get.snackbar(
                                'Lỗi', 'Vui lòng thêm ít nhất 1 món ăn');
                            return;
                          }

                          // ✅ FIX: Explicitly cast to double
                          final price =
                              double.parse(priceController.text.trim());
                          final guestsPerTable =
                              int.parse(guestsController.text.trim());
                          final pricePerPerson =
                              (price / guestsPerTable).toDouble();

                          final menuItem = MenuModel(
                            id: existingMenu?.id,
                            name: nameController.text.trim(),
                            description: descController.text.trim(),
                            price: price,
                            guestsPerTable: guestsPerTable,
                            pricePerPerson: pricePerPerson,
                            items: dishes.toList(),
                          );

                          if (existingMenu == null) {
                            controller.addMenuItem(menuItem);
                          } else {
                            controller.updateMenuItem(index!, menuItem);
                          }

                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: WColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          existingMenu == null ? 'Thêm Menu' : 'Cập nhật',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
