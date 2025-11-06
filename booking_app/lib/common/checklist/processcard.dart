import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:booking_app/features/controller/checklist_controller.dart';
import 'package:booking_app/models/checklist_response.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

// =====================================================
// 1. PROGRESS CARD - Hiển thị tiến độ
// =====================================================
class ProgressCard extends StatelessWidget {
  final CheckListController controller;

  const ProgressCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckListController>(
      init: controller,
      builder: (ctrl) {
        final completed = ctrl.items.where((item) => item.isCompleted).length;
        final total = ctrl.items.length;
        final progress = total > 0 ? completed / total : 0.0;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [WColors.primary, Color(0xFF8B7355)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: WColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tiến độ chuẩn bị',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Checklist đám cưới',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      '$completed/$total',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(progress * 100).toInt()}% hoàn thành',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (total > 0)
                    Text(
                      '${total - completed} mục còn lại',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// =====================================================
// 2. CHECKLIST CARD - Card cho từng item
// =====================================================
class CheckListCard extends StatelessWidget {
  final CheckListItem item;
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
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isCompleted
              ? Colors.green.withOpacity(0.3)
              : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.toggleItem(index),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCheckbox(),
                const SizedBox(width: 16),
                Expanded(child: _buildContent()),
                _buildActionsMenu(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Custom checkbox đẹp hơn
  Widget _buildCheckbox() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: item.isCompleted ? Colors.green : Colors.transparent,
        border: Border.all(
          color: item.isCompleted ? Colors.green : Colors.grey.shade400,
          width: 2,
        ),
      ),
      child: item.isCompleted
          ? const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 18,
            )
          : null,
    );
  }

  // ✅ Nội dung card
  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: item.isCompleted ? Colors.grey.shade600 : Colors.black87,
            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
            decorationColor: Colors.grey.shade400,
            decorationThickness: 2,
          ),
        ),
        if (item.description != null && item.description!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            item.description!,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              height: 1.4,
              decoration: item.isCompleted ? TextDecoration.lineThrough : null,
              decorationColor: Colors.grey.shade400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 12),
        _buildMetadata(),
      ],
    );
  }

  // ✅ Metadata (ngày tạo, ngày hoàn thành)
  Widget _buildMetadata() {
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: [
        if (item.createdAt != null)
          _buildMetaItem(
            Iconsax.calendar,
            _formatDate(item.createdAt!),
            Colors.grey.shade600,
          ),
        if (item.isCompleted && item.completedAt != null)
          _buildMetaItem(
            Iconsax.tick_circle,
            'Hoàn thành ${_formatDate(item.completedAt!)}',
            Colors.green.shade600,
          ),
      ],
    );
  }

  Widget _buildMetaItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ✅ Menu actions (Edit, Delete)
  Widget _buildActionsMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Iconsax.more, color: Colors.grey.shade600, size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: const Offset(0, 40),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: WColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Iconsax.edit,
                  color: WColors.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Chỉnh sửa'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Iconsax.trash,
                  color: Colors.red,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Xóa',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'edit') {
          _showEditDialog(context);
        } else if (value == 'delete') {
          _showDeleteDialog(context);
        }
      },
    );
  }

  // ✅ Dialog chỉnh sửa
  void _showEditDialog(BuildContext context) {
    final titleController = TextEditingController(text: item.title);
    final descController = TextEditingController(text: item.description ?? '');

    Get.dialog(
      ItemDialog(
        title: 'Chỉnh sửa mục',
        buttonText: 'Cập nhật',
        titleController: titleController,
        descController: descController,
        onConfirm: () {
          final title = titleController.text.trim();
          if (title.isEmpty) {
            Get.snackbar(
              '⚠️ Lỗi',
              'Vui lòng nhập tiêu đề',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.orange.withOpacity(0.1),
              colorText: Colors.orange,
            );
            return;
          }

          controller.updateItem(
            index,
            title,
            descController.text.trim().isEmpty
                ? null
                : descController.text.trim(),
          );
          Get.back();
        },
      ),
    );
  }

  // ✅ Dialog xác nhận xóa
  void _showDeleteDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Iconsax.warning_2, color: Colors.red),
            ),
            const SizedBox(width: 12),
            const Text(
              'Xác nhận xóa',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
            children: [
              const TextSpan(text: 'Bạn có chắc chắn muốn xóa mục\n'),
              TextSpan(
                text: '"${item.title}"',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: WColors.primary,
                ),
              ),
              const TextSpan(text: '?'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Hủy',
              style: TextStyle(color: Colors.grey.shade600),
            ),
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

  // ✅ Format date helper
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final itemDate = DateTime(date.year, date.month, date.day);

    if (itemDate == today) {
      return 'Hôm nay ${DateFormat('HH:mm').format(date)}';
    } else if (itemDate == yesterday) {
      return 'Hôm qua ${DateFormat('HH:mm').format(date)}';
    } else if (now.difference(date).inDays < 7) {
      return DateFormat('EEEE HH:mm', 'vi_VN').format(date);
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    }
  }
}

// =====================================================
// 3. ITEM DIALOG - Dialog thêm/sửa item
// =====================================================
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
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: WColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Iconsax.note_1,
              color: WColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: WColors.primary,
              fontSize: 18,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: titleController,
              label: 'Tiêu đề',
              hint: 'Nhập tiêu đề công việc...',
              icon: Iconsax.text,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: descController,
              label: 'Mô tả (tùy chọn)',
              hint: 'Nhập mô tả chi tiết...',
              icon: Iconsax.note,
              maxLines: 4,
            ),
            const SizedBox(height: 8),
            Text(
              '* Trường bắt buộc',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Hủy',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: WColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: Text(buttonText),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        labelStyle: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: Icon(icon, color: WColors.primary, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: WColors.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
