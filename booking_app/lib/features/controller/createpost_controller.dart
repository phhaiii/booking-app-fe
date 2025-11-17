import 'dart:io';
import 'package:booking_app/model/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:booking_app/service/venue_service.dart';
import 'package:booking_app/service/menu_service.dart';

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
  var existingImageUrls = <String>[].obs; // For edit mode
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
  var allowComments = true.obs;
  var enableNotifications = true.obs;
  var isLoading = false.obs;
  var contentLength = 0.obs;

  // ✅ THÊM: Menu items management
  var menuItems = <MenuModel>[].obs;

  // ✅ THÊM: Edit mode support
  var isEditMode = false.obs;
  String? editingVenueId;
  String? editingPostOwnerId;

  @override
  void onInit() {
    super.onInit();
    contentController.addListener(() {
      contentLength.value = contentController.text.length;
    });

    // Load venue data if in edit mode
    if (Get.arguments != null && Get.arguments['venue'] != null) {
      isEditMode.value = true;
      loadVenueData(Get.arguments['venue']);
    }
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
        backgroundColor: Colors.transparent,
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

  void addMenuItem(MenuModel item) {
    menuItems.add(item);
    Get.snackbar(
      '✅ Thành công',
      'Đã thêm set menu: ${item.name}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.transparent,
      colorText: Colors.green,
      duration: const Duration(seconds: 2),
    );
  }

  void updateMenuItem(int index, MenuModel item) {
    if (index >= 0 && index < menuItems.length) {
      menuItems[index] = item;
      Get.snackbar(
        'Đã cập nhật',
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
        backgroundColor: Colors.transparent,
        colorText: Colors.orange,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // ============================================================================
  // EDIT MODE METHODS
  // ============================================================================

  void loadVenueData(dynamic venue) {
    print('📝 Loading venue data for editing');

    editingVenueId = venue.id?.toString();
    editingPostOwnerId = venue.vendor?.id?.toString();

    titleController.text = venue.title ?? '';
    descriptionController.text = venue.description ?? '';
    contentController.text = venue.content ?? '';
    locationController.text = venue.location ?? '';
    priceController.text = venue.price?.toString() ?? '';
    capacityController.text = venue.capacity?.toString() ?? '';

    if (venue.style != null && styles.contains(venue.style)) {
      selectedStyle.value = venue.style;
    }

    if (venue.images != null && venue.images.isNotEmpty) {
      existingImageUrls.value = List<String>.from(venue.images);
    }

    if (venue.amenities != null && venue.amenities.isNotEmpty) {
      selectedAmenities.value = List<String>.from(venue.amenities);
    }

    allowComments.value = venue.allowComments ?? true;
    enableNotifications.value = venue.enableNotifications ?? true;

    print('✅ Venue data loaded for editing');
  }

  void removeExistingImage(int index) {
    if (index >= 0 && index < existingImageUrls.length) {
      existingImageUrls.removeAt(index);
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
        backgroundColor: Colors.transparent,
        colorText: Colors.orange,
      );
      return false;
    }

    // In edit mode, allow empty images if existing images exist
    if (selectedImages.isEmpty && existingImageUrls.isEmpty) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng thêm ít nhất 1 hình ảnh',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.transparent,
        colorText: Colors.orange,
      );
      return false;
    }

    // ✅ Menu KHÔNG bắt buộc nữa
    if (menuItems.isEmpty) {
      print('⚠️ No menu items (optional)');
    }

    return true;
  }

  Future<void> publishPost() async {
    if (isEditMode.value) {
      await updatePost();
    } else {
      await createPost();
    }
  }

  Future<void> createPost() async {
    print('═══════════════════════════════════════');
    print('CREATE POST CALLED');
    print('═══════════════════════════════════════');

    // ✅ Validate form
    if (!formKey.currentState!.validate()) {
      print('❌ Form validation failed');
      Get.snackbar(
        'Lỗi',
        'Vui lòng điền đầy đủ thông tin',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // ✅ Validate images
    if (selectedImages.isEmpty) {
      print('❌ No images selected');
      Get.snackbar(
        'Lỗi',
        'Vui lòng chọn ít nhất 1 ảnh',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // ✅ Validate amenities
    if (selectedAmenities.isEmpty) {
      print('❌ No amenities selected');
      Get.snackbar(
        'Lỗi',
        'Vui lòng chọn ít nhất 1 tiện nghi',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;
      print('Starting post creation...');

      final imagePaths = selectedImages.map((file) => file.path).toList();
      print('Image paths: $imagePaths');

      // ✅ DEBUG: Check menuItems
      print('═══════════════════════════════════════');
      print('MENU ITEMS CHECK');
      print('Menu items count: ${menuItems.length}');
      print('Menu items: $menuItems');
      for (var i = 0; i < menuItems.length; i++) {
        print(
            '  [$i] ${menuItems[i].name} - ${menuItems[i].price}đ - ${menuItems[i].items.length} items');
      }
      print('═══════════════════════════════════════');

      // ✅ Convert menuItems
      List<Map<String, dynamic>>? menuData;
      if (menuItems.isNotEmpty) {
        menuData = menuItems.map((item) {
          return {
            'name': item.name,
            'description': item.description,
            'price': item.price,
            'pricePerPerson': item.pricePerPerson,
            'items': item.dishes,
            'minGuests': item.guestsPerTable,
            'maxGuests': item.guestsPerTable,
          };
        }).toList();
        print('Menu data prepared: ${menuData.length} items');
      }

      print('═══════════════════════════════════════');
      print('CALLING VenueService.createVenue()');
      print('═══════════════════════════════════════');

      final result = await VenueService.createVenue(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        content: contentController.text.trim(),
        location: locationController.text.trim(),
        price: double.parse(priceController.text.trim()),
        capacity: int.parse(capacityController.text.trim()),
        imagePaths: imagePaths,
        amenities: selectedAmenities.toList(),
        style: selectedStyle.value,
        allowComments: allowComments.value,
        enableNotifications: enableNotifications.value,
        menuItems: menuData,
      );

      print('═══════════════════════════════════════');
      print('RESULT RECEIVED');
      print('Result: $result');
      print('═══════════════════════════════════════');

      // ✅ Check for error
      if (result != null && result.containsKey('error')) {
        print('❌ Error in result: ${result['error']}');

        Get.snackbar(
          '❌ Lỗi',
          result['message'] ?? 'Không thể tạo bài viết',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 4),
        );
        return;
      }

      // ✅ Success
      if (result != null && result['id'] != null) {
        print('✅ Post created successfully with ID: ${result['id']}');
        final postId = result['id'] as int;

        // ✅ CREATE MENUS if any
        if (menuItems.isNotEmpty) {
          print('═══════════════════════════════════════');
          print('CREATING ${menuItems.length} MENUS FOR POST $postId');
          print('═══════════════════════════════════════');

          for (int i = 0; i < menuItems.length; i++) {
            final menu = menuItems[i];
            print('Creating menu ${i + 1}/${menuItems.length}: ${menu.name}');

            try {
              final createdMenu = await MenuService.createMenu(
                postId: postId,
                name: menu.name,
                description: menu.description,
                price: menu.price,
                guestsPerTable: menu.guestsPerTable,
                items: menu.items,
              );

              if (createdMenu != null) {
                print('✅ Menu created: ${createdMenu.name}');
              } else {
                print('⚠️ Failed to create menu: ${menu.name}');
              }
            } catch (e) {
              print('❌ Error creating menu ${menu.name}: $e');
            }
          }

          print('═══════════════════════════════════════');
          print('✅ MENU CREATION COMPLETED');
          print('═══════════════════════════════════════');
        }

        Get.snackbar(
          '✅ Thành công',
          'Bài viết đã được tạo thành công!',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.check_circle, color: Colors.green),
        );

        // ✅ Clear form
        _clearForm();

        // ✅ Navigate back after delay
        await Future.delayed(const Duration(seconds: 1));
        Get.back();
      } else {
        print('❌ Invalid result format');

        Get.snackbar(
          '❌ Lỗi',
          'Response không hợp lệ từ server',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e, stackTrace) {
      print('❌ EXCEPTION in publishPost: $e');
      print('Stack trace: $stackTrace');

      Get.snackbar(
        '❌ Lỗi',
        'Đã có lỗi xảy ra: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
      print('═══════════════════════════════════════');
      print('PUBLISH POST FINISHED');
      print('═══════════════════════════════════════');
    }
  }

  Future<void> updatePost() async {
    print('═══════════════════════════════════════');
    print('UPDATE POST CALLED');
    print('Editing venue ID: $editingVenueId');
    print('═══════════════════════════════════════');

    if (editingVenueId == null || editingPostOwnerId == null) {
      Get.snackbar(
        '❌ Lỗi',
        'Không tìm thấy thông tin bài viết cần chỉnh sửa',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Validate form
    if (!_validateForm()) {
      return;
    }

    try {
      isLoading.value = true;

      print('📝 Preparing update...');
      print('   Existing images: ${existingImageUrls.length}');
      print('   New images: ${selectedImages.length}');

      final imagePaths = selectedImages.map((file) => file.path).toList();

      final result = await VenueService.updateVenue(
        venueId: editingVenueId!,
        postOwnerId: editingPostOwnerId!,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        content: contentController.text.trim(),
        location: locationController.text.trim(),
        price: double.parse(priceController.text.trim()),
        capacity: int.parse(capacityController.text.trim()),
        amenities: selectedAmenities.toList(),
        style: selectedStyle.value,
        imagePaths: imagePaths.isNotEmpty ? imagePaths : null,
        existingImageUrls: existingImageUrls.toList(),
      );

      if (result != null && result.containsKey('error')) {
        Get.snackbar(
          '❌ Lỗi',
          result['message'] ?? 'Không thể cập nhật bài viết',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 4),
        );
        return;
      }

      if (result != null) {
        Get.snackbar(
          '✅ Thành công',
          'Bài viết đã được cập nhật!',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.check_circle, color: Colors.green),
        );

        await Future.delayed(const Duration(seconds: 1));
        Get.back(result: true); // Return true to indicate success
      }
    } catch (e, stackTrace) {
      print('❌ EXCEPTION in updatePost: $e');
      print('Stack trace: $stackTrace');

      Get.snackbar(
        '❌ Lỗi',
        'Đã có lỗi xảy ra: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
      print('═══════════════════════════════════════');
      print('UPDATE POST FINISHED');
      print('═══════════════════════════════════════');
    }
  }

  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    contentController.clear();
    locationController.clear();
    priceController.clear();
    capacityController.clear();
    selectedImages.clear();
    existingImageUrls.clear();
    selectedAmenities.clear();
    menuItems.clear();
    selectedStyle.value = 'Sang trọng';
    allowComments.value = true;
    enableNotifications.value = true;
    isEditMode.value = false;
    editingVenueId = null;
    editingPostOwnerId = null;
  }
}
