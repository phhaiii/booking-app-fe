import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:booking_app/service/api.dart';
import 'package:booking_app/service/storage_service.dart';
import 'package:booking_app/models/user_response.dart';
import 'package:booking_app/models/api_response.dart';
import 'package:booking_app/features/screen/login/login.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  // Observable variables
  final isLoading = false.obs;
  final user = Rx<UserResponse?>(null);
  final isChangingPassword = false.obs;

  // THÊM MỚI - Avatar management
  var selectedAvatarPath = ''.obs;
  var isUploadingAvatar = false.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  // Load user profile from API
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      print('Loading user profile...');

      // Get user ID from storage
      final userId = await StorageService.getUserId();
      if (userId == null || userId.isEmpty) {
        print('No user ID found in storage');
        throw Exception('Không tìm thấy thông tin người dùng');
      }

      print('User ID: $userId');

      // Call API to get user profile
      final response = await ApiService.get('/users/$userId');
      print('Profile response: $response');

      // Parse response
      final apiResponse = ApiResponse<UserResponse>.fromJson(
        response,
        (data) => UserResponse.fromJson(data),
      );

      if (apiResponse.success && apiResponse.data != null) {
        user.value = apiResponse.data;
        print('User profile loaded successfully');
        print('User: ${user.value?.toJson()}');
      } else {
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      print('Error loading profile: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể tải thông tin cá nhân: $e',
        backgroundColor: Colors.transparent,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh profile data
  Future<void> refreshProfile() async {
    await loadUserProfile();
  }

  // Change password
  Future<void> changePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    // Validate inputs
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng điền đầy đủ thông tin',
        backgroundColor: Colors.transparent,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Lỗi',
        'Mật khẩu xác nhận không khớp',
        backgroundColor: Colors.transparent,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar(
        'Lỗi',
        'Mật khẩu mới phải có ít nhất 6 ký tự',
        backgroundColor: Colors.transparent,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isChangingPassword.value = true;
      print('🔒 Changing password...');

      final requestBody = {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      };

      final response =
          await ApiService.put('/users/change-password', body: requestBody);
      print('Change password response: $response');

      final apiResponse = ApiResponse.fromJson(response, (data) => data);

      if (apiResponse.success) {
        Get.snackbar(
          'Thành công',
          'Đã đổi mật khẩu thành công',
          backgroundColor: Colors.transparent,
          colorText: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        print('Password changed successfully');
      } else {
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      print('Error changing password: $e');

      String errorMessage = 'Có lỗi xảy ra khi đổi mật khẩu';
      if (e.toString().contains('current password') ||
          e.toString().contains('mật khẩu hiện tại')) {
        errorMessage = 'Mật khẩu hiện tại không đúng';
      } else if (e.toString().contains('Exception:')) {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      }

      Get.snackbar(
        'Lỗi',
        errorMessage,
        backgroundColor: Colors.transparent,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isChangingPassword.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      print('Logging out...');

      // Call logout API if available
      try {
        await ApiService.post('/auth/logout', body: {});
      } catch (e) {
        print('Logout API failed: $e');
        // Continue with local logout even if API fails
      }

      // Clear local storage
      await StorageService.clearAll();

      // Clear user data
      user.value = null;

      Get.snackbar(
        'Đăng xuất thành công',
        'Bạn đã đăng xuất khỏi ứng dụng',
        backgroundColor: Colors.transparent,
        colorText: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // Navigate to login screen
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAll(() => const LoginScreen());

      print('Logout successful');
    } catch (e) {
      print('Logout error: $e');
      Get.snackbar(
        'Lỗi',
        'Có lỗi xảy ra khi đăng xuất',
        backgroundColor: Colors.transparent,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // THÊM MỚI - Change profile picture method
  Future<void> changeProfilePicture() async {
    try {
      // Show source selection dialog
      final source = await _showImageSourceDialog();
      if (source == null) return;

      // Pick image
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        isUploadingAvatar.value = true;

        // Simulate upload process
        await Future.delayed(const Duration(seconds: 2));

        // Update avatar path
        selectedAvatarPath.value = image.path;

        Get.snackbar(
          'Thành công',
          'Ảnh đại diện đã được cập nhật',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể cập nhật ảnh đại diện: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUploadingAvatar.value = false;
    }
  }

  // THÊM MỚI - Show image source selection dialog
  Future<ImageSource?> _showImageSourceDialog() async {
    return await Get.dialog<ImageSource>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Chọn nguồn ảnh',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: WColors.primary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Camera option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Iconsax.camera, color: Colors.blue),
              ),
              title: const Text('Chụp ảnh'),
              subtitle: const Text('Sử dụng camera để chụp ảnh mới'),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            const SizedBox(height: 8),

            // Gallery option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Iconsax.gallery, color: Colors.green),
              ),
              title: const Text('Thư viện ảnh'),
              subtitle: const Text('Chọn ảnh từ thư viện'),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Hủy',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  // THÊM MỚI - Remove profile picture
  Future<void> removeProfilePicture() async {
    try {
      selectedAvatarPath.value = '';

      Get.snackbar(
        'Thành công',
        'Đã xóa ảnh đại diện',
        backgroundColor: Colors.orange.withOpacity(0.1),
        colorText: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể xóa ảnh đại diện',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Helper methods for UI
  String get fullName => user.value?.fullName ?? 'Chưa cập nhật';
  String get email => user.value?.email ?? 'Chưa cập nhật';
  String get phone => user.value?.phone ?? 'Chưa cập nhật';
  String get address => user.value?.address ?? 'Chưa cập nhật';
  String get dateOfBirth => user.value?.dateOfBirth ?? 'Chưa cập nhật';
  String get userId => user.value?.id.toString() ?? 'Chưa có';

  // Format date for display
  String get formattedDateOfBirth {
    if (user.value?.dateOfBirth == null || user.value!.dateOfBirth!.isEmpty) {
      return 'Chưa cập nhật';
    }

    try {
      final date = DateTime.parse(user.value!.dateOfBirth!);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return user.value!.dateOfBirth!;
    }
  }

  // Current avatar (fallback to default if no custom avatar)
  String get currentAvatar {
    return selectedAvatarPath.value.isNotEmpty
        ? selectedAvatarPath.value
        : WImages.splash;
  }
}
