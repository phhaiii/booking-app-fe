import 'dart:io';
import 'package:booking_app/formatter/venue/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:booking_app/service/venue_service.dart';

class CreatePostController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final contentController = TextEditingController();
  final locationController = TextEditingController();
  final priceController = TextEditingController();
  final capacityController = TextEditingController();

  // Observables
  var selectedImages = <File>[].obs;
  var selectedAmenities = <String>[].obs;
  var availableAmenities = <String>[
    'Bãi đỗ xe',
    'WiFi miễn phí',
    'Điều hòa',
    'Âm thanh chuyên nghiệp',
    'Ánh sáng LED',
    'Phòng thay đồ',
    'Trang trí miễn phí',
    'MC chuyên nghiệp',
    'Phục vụ rượu',
  ].obs;

  var selectedStyle = 'Sang trọng'.obs;
  final styles = [
    'Sang trọng',
    'Hiện đại',
    'Cổ điển',
    'Rustic',
    'Garden',
    'Beach',
    'Vintage',
  ];

  var isLoading = false.obs;
  var contentLength = 0.obs;

  // ✅ THÊM: Menu items management
  var menuItems = <MenuItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    contentController.addListener(() {
      contentLength.value = contentController.text.length;
    });
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    contentController.dispose();
    locationController.dispose();
    priceController.dispose();
    capacityController.dispose();
    super.onClose();
  }

  // ============================================================================
  // IMAGE METHODS
  // ============================================================================

  Future<void> pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();

      if (images.isNotEmpty) {
        selectedImages.addAll(images.map((image) => File(image.path)));
        Get.snackbar(
          'Thành công',
          'Đã thêm ${images.length} ảnh',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể chọn ảnh: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
      Get.snackbar(
        'Đã xóa',
        'Đã xóa ảnh',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    }
  }

  // ============================================================================
  // AMENITY METHODS
  // ============================================================================

  void toggleAmenity(String amenity) {
    if (selectedAmenities.contains(amenity)) {
      selectedAmenities.remove(amenity);
    } else {
      selectedAmenities.add(amenity);
    }
  }

  // ============================================================================
  // ✅ MENU METHODS
  // ============================================================================

  void addMenuItem(MenuItem item) {
    menuItems.add(item);
    Get.snackbar(
      '✅ Thành công',
      'Đã thêm set menu: ${item.name}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
      duration: const Duration(seconds: 2),
    );
  }

  void updateMenuItem(int index, MenuItem item) {
    if (index >= 0 && index < menuItems.length) {
      menuItems[index] = item;
      Get.snackbar(
        '✅ Đã cập nhật',
        'Cập nhật set menu thành công',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void removeMenuItem(int index) {
    if (index >= 0 && index < menuItems.length) {
      final item = menuItems[index];
      menuItems.removeAt(index);
      Get.snackbar(
        '🗑️ Đã xóa',
        'Đã xóa set menu: ${item.name}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.1),
        colorText: Colors.orange,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // ============================================================================
  // VALIDATION & PUBLISH METHODS
  // ============================================================================

  bool _validateForm() {
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng điền đầy đủ thông tin bắt buộc',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.1),
        colorText: Colors.orange,
      );
      return false;
    }

    if (selectedImages.isEmpty) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng thêm ít nhất 1 hình ảnh',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.1),
        colorText: Colors.orange,
      );
      return false;
    }

    if (menuItems.isEmpty) {
      Get.snackbar(
        'Cảnh báo',
        'Bạn chưa thêm set menu nào. Tiếp tục?',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.1),
        colorText: Colors.orange,
        duration: const Duration(seconds: 3),
      );
    }

    return true;
  }

  Future<void> publishPost() async {
    if (!_validateForm()) return;

    try {
      isLoading.value = true;

      // Prepare data
      final title = titleController.text.trim();
      final description = descriptionController.text.trim();
      final content = contentController.text.trim();
      final location = locationController.text.trim();
      final price = double.parse(priceController.text.trim());
      final capacity = int.parse(capacityController.text.trim());

      // Get image paths
      final imagePaths = selectedImages.map((file) => file.path).toList();

      // Create venue with menu items
      final result = await VenueService.createVenue(
        title: title,
        description: description,
        content: content,
        location: location,
        price: price,
        capacity: capacity,
        imagePaths: imagePaths,
        amenities: selectedAmenities.toList(),
        style: selectedStyle.value,
        allowComments: true,
        enableNotifications: true,
        // ✅ THÊM: Menu items as JSON
        menuItems: menuItems.map((item) => item.toJson()).toList(),
      );

      if (result != null) {
        Get.snackbar(
          '✅ Thành công',
          'Bài viết đã được xuất bản',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 3),
        );

        // Clear form
        _clearForm();

        // Navigate back
        Get.back();
      } else {
        Get.snackbar(
          '❌ Lỗi',
          'Không thể xuất bản bài viết',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        '❌ Lỗi',
        'Đã xảy ra lỗi: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void previewPost() {
    if (!_validateForm()) return;

    Get.snackbar(
      '👁️ Xem trước',
      'Chức năng xem trước đang được phát triển',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    contentController.clear();
    locationController.clear();
    priceController.clear();
    capacityController.clear();
    selectedImages.clear();
    selectedAmenities.clear();
    menuItems.clear();
    selectedStyle.value = 'Sang trọng';
  }
}
