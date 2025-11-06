import 'package:get/get.dart';
import 'package:booking_app/models/checklist_response.dart';
import 'package:booking_app/service/checklist_service.dart';

class CheckListController extends GetxController {
  final CheckListService _service = CheckListService();

  final RxList<CheckListItem> items = <CheckListItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // ✅ Statistics
  final RxInt completedCount = 0.obs;
  final RxInt incompleteCount = 0.obs;
  final RxInt totalCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadItems();
  }

  // Tính toán progress từ items hiện tại
  double get progress {
    if (items.isEmpty) return 0.0;
    final completed = items.where((item) => item.isCompleted).length;
    return completed / items.length;
  }

  // ✅ Load items + statistics
  Future<void> loadItems() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Load items
      final loadedItems = await _service.getAll();
      items.value = loadedItems;

      // Load statistics (optional - có thể dùng để verify)
      try {
        final stats = await _service.getStatistics();
        completedCount.value = stats['completed'] ?? 0;
        incompleteCount.value = stats['incomplete'] ?? 0;
        totalCount.value = stats['total'] ?? 0;
      } catch (e) {
        print('⚠️ Cannot load statistics: $e');
      }

      update();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();

      Get.snackbar(
        '❌ Lỗi',
        'Không thể tải dữ liệu: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // ✅ Các method khác giữ nguyên như cũ
  Future<void> addItem(String title, String? description) async {
    try {
      isLoading.value = true;

      final newItem = CheckListItem(
        title: title.trim(),
        description: description?.trim(),
      );

      final created = await _service.create(newItem);
      items.add(created);

      Get.snackbar(
        '✅ Thành công',
        'Đã thêm mục mới',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
        colorText: Get.theme.colorScheme.primary,
      );

      update();
    } catch (e) {
      Get.snackbar(
        '❌ Lỗi',
        'Không thể thêm mục: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateItem(int index, String title, String? description) async {
    try {
      isLoading.value = true;

      final item = items[index];
      if (item.id == null) {
        throw Exception('Item không có ID');
      }

      final updatedItem = CheckListItem(
        id: item.id,
        title: title.trim(),
        description: description?.trim(),
        isCompleted: item.isCompleted,
        createdAt: item.createdAt,
        completedAt: item.completedAt,
      );

      final updated = await _service.update(item.id!, updatedItem);
      items[index] = updated;

      Get.snackbar(
        '✅ Đã cập nhật',
        'Mục đã được cập nhật',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
        colorText: Get.theme.colorScheme.primary,
      );

      update();
    } catch (e) {
      Get.snackbar(
        '❌ Lỗi',
        'Không thể cập nhật: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteItem(int index) async {
    try {
      isLoading.value = true;

      final item = items[index];
      if (item.id == null) {
        throw Exception('Item không có ID');
      }

      await _service.delete(item.id!);
      items.removeAt(index);

      Get.snackbar(
        '✅ Đã xóa',
        'Mục đã được xóa',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
      );

      update();
    } catch (e) {
      Get.snackbar(
        '❌ Lỗi',
        'Không thể xóa: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleItem(int index) async {
    try {
      final item = items[index];
      if (item.id == null) {
        throw Exception('Item không có ID');
      }

      final updated = await _service.toggleCompleted(item.id!);
      items[index] = updated;

      Get.snackbar(
        updated.isCompleted ? '✅ Hoàn thành' : '⏳ Chưa hoàn thành',
        updated.title,
        snackPosition: SnackPosition.TOP,
        backgroundColor: updated.isCompleted
            ? Get.theme.colorScheme.primary.withOpacity(0.1)
            : Get.theme.colorScheme.secondary.withOpacity(0.1),
        colorText: updated.isCompleted
            ? Get.theme.colorScheme.primary
            : Get.theme.colorScheme.secondary,
      );

      update();
    } catch (e) {
      Get.snackbar(
        '❌ Lỗi',
        'Không thể cập nhật trạng thái: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
      );
    }
  }
}
