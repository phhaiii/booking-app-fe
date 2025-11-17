import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/features/controller/checklist_controller.dart';
import 'package:booking_app/common/checklist/processcard.dart';

class CheckListScreen extends StatelessWidget {
  const CheckListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: Dùng Get.find hoặc Get.put với tag
    final controller = Get.put(CheckListController(), permanent: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Check List Cưới',
          style: TextStyle(
            color: WColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => _showAddDialog(context, controller),
            icon: const Icon(Iconsax.add_circle, color: WColors.primary),
            tooltip: 'Thêm mới',
          ),
        ],
      ),
      body: GetBuilder<CheckListController>(
        init: controller,
        builder: (ctrl) {
          if (ctrl.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: WColors.primary),
            );
          }

          if (ctrl.hasError.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Có lỗi xảy ra',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Không thể tải dữ liệu checklist',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: ctrl.loadItems,
                    icon: const Icon(Iconsax.refresh),
                    label: const Text('Thử lại'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: ctrl.loadItems,
            color: WColors.primary,
            child: Padding(
              padding: const EdgeInsets.all(WSizes.defaultSpace),
              child: Column(
                children: [
                  ProgressCard(controller: ctrl),
                  const SizedBox(height: WSizes.spaceBtwSections),
                  Expanded(
                    child: ctrl.items.isEmpty
                        ? _buildEmptyState(context, ctrl)
                        : _buildList(context, ctrl),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, CheckListController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.note, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Chưa có mục nào',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nhấn + để thêm mục mới',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddDialog(context, controller),
            icon: const Icon(Iconsax.add),
            label: const Text('Thêm mục đầu tiên'),
            style: ElevatedButton.styleFrom(
              backgroundColor: WColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, CheckListController controller) {
    return ListView.separated(
      itemCount: controller.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: WSizes.spaceBtwItems),
      itemBuilder: (context, index) {
        final item = controller.items[index];
        return CheckListCard(
          item: item,
          index: index,
          controller: controller,
        );
      },
    );
  }

  void _showAddDialog(BuildContext context, CheckListController controller) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    Get.dialog(
      ItemDialog(
        title: 'Thêm mục mới',
        buttonText: 'Thêm',
        titleController: titleController,
        descController: descController,
        onConfirm: () {
          if (titleController.text.trim().isEmpty) {
            Get.snackbar(
              '⚠️ Lỗi',
              'Vui lòng nhập tiêu đề',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.orange.withOpacity(0.1),
              colorText: Colors.orange,
            );
            return;
          }
          controller.addItem(
            titleController.text.trim(),
            descController.text.trim().isEmpty
                ? null
                : descController.text.trim(),
          );
          Get.back();
        },
      ),
    );
  }
}

// ✅ Widget Card cho từng item
class CheckListCard extends StatelessWidget {
  final dynamic item;
  final int index;
  final CheckListController controller;

  const CheckListCard({
    super.key,
    required this.item,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isCompleted
              ? Colors.green.withOpacity(0.3)
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Checkbox(
          value: item.isCompleted,
          onChanged: (_) => controller.toggleItem(index),
          activeColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
            color: item.isCompleted ? Colors.grey : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: item.description != null && item.description!.isNotEmpty
            ? Text(
                item.description!,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: PopupMenuButton(
          icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Iconsax.edit, size: 18),
                  SizedBox(width: 8),
                  Text('Chỉnh sửa'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Iconsax.trash, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Xóa', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              _showEditDialog(context, controller, index, item);
            } else if (value == 'delete') {
              _showDeleteConfirm(context, controller, index, item);
            }
          },
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    CheckListController controller,
    int index,
    dynamic item,
  ) {
    final titleController = TextEditingController(text: item.title);
    final descController = TextEditingController(text: item.description ?? '');

    Get.dialog(
      ItemDialog(
        title: 'Chỉnh sửa mục',
        buttonText: 'Cập nhật',
        titleController: titleController,
        descController: descController,
        onConfirm: () {
          if (titleController.text.trim().isEmpty) {
            Get.snackbar(
              '⚠️ Lỗi',
              'Vui lòng nhập tiêu đề',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.orange.shade50,
              colorText: Colors.orange.shade900,
            );
            return;
          }
          controller.updateItem(
            index,
            titleController.text.trim(),
            descController.text.trim().isEmpty
                ? null
                : descController.text.trim(),
          );
          Get.back();
        },
      ),
    );
  }

  void _showDeleteConfirm(
    BuildContext context,
    CheckListController controller,
    int index,
    dynamic item,
  ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Iconsax.warning_2, color: Colors.red),
            SizedBox(width: 12),
            Text('Xác nhận xóa', style: TextStyle(fontSize: 18)),
          ],
        ),
        content: Text('Bạn có chắc chắn muốn xóa mục "${item.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteItem(index);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}

// ✅ Dialog thêm/sửa
class ItemDialog extends StatelessWidget {
  final String title;
  final String buttonText;
  final TextEditingController titleController;
  final TextEditingController descController;
  final VoidCallback onConfirm;

  const ItemDialog({
    super.key,
    required this.title,
    required this.buttonText,
    required this.titleController,
    required this.descController,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Tiêu đề *',
              hintText: 'Nhập tiêu đề...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Iconsax.text),
            ),
            maxLength: 100,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descController,
            decoration: InputDecoration(
              labelText: 'Mô tả (tùy chọn)',
              hintText: 'Nhập mô tả...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Iconsax.note_1),
            ),
            maxLines: 3,
            maxLength: 500,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: WColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(buttonText),
        ),
      ],
    );
  }
}
