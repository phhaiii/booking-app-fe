import 'package:booking_app/common/splash/section_heading.dart';
import 'package:booking_app/features/controller/profile_controller.dart';
import 'package:booking_app/features/screen/profile/profile_menu.dart';
import 'package:booking_app/features/screen/profile/profile_ava.dart'; 
import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân',
            style: TextStyle(color: WColors.primary)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: controller.refreshProfile,
            icon: const Icon(Iconsax.refresh, color: WColors.primary),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.user.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: WColors.primary),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshProfile,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(WSizes.defaultSpace),
            child: Column(
              children: [
                // SỬA: Profile picture section
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      // Custom Avatar với loading state
                      Obx(() => ProfileAvatar(
                            imagePath: controller.currentAvatar,
                            width: 100,
                            height: 100,
                            isLoading: controller.isUploadingAvatar.value,
                            onTap: () =>
                                _showAvatarOptions(context, controller),
                            onLongPress: () =>
                                _showAvatarPreview(context, controller),
                          )),

                      const SizedBox(height: 8),

                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: controller.isUploadingAvatar.value
                                ? null
                                : () => controller.changeProfilePicture(),
                            icon: const Icon(Iconsax.camera, size: 16),
                            label: const Text('Thay đổi ảnh'),
                            style: TextButton.styleFrom(
                              foregroundColor: WColors.primary,
                            ),
                          ),
                          if (controller
                              .selectedAvatarPath.value.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: controller.isUploadingAvatar.value
                                  ? null
                                  : () => _showRemoveAvatarDialog(
                                      context, controller),
                              icon: const Icon(Iconsax.trash, size: 16),
                              label: const Text('Xóa'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: WSizes.spaceBtwItems / 2),
                const Divider(),
                const SizedBox(height: WSizes.spaceBtwItems),

                // Profile info
                const WSectionHeading(
                    title: 'Thông tin cá nhân', showActionButton: false),
                const SizedBox(height: WSizes.spaceBtwItems),

                WProfileMenu(
                  title: 'Họ và tên',
                  value: controller.fullName,
                  onPressed: () {},
                ),
                WProfileMenu(
                  title: 'Email',
                  value: controller.email,
                  icon: Iconsax.copy,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: controller.email));
                    Get.snackbar(
                      'Đã sao chép',
                      'Email đã được sao chép',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  },
                ),

                const SizedBox(height: WSizes.spaceBtwItems / 2),
                const Divider(),
                const SizedBox(height: WSizes.spaceBtwItems),

                // Contact info
                const WSectionHeading(
                    title: 'Thông tin liên hệ', showActionButton: false),
                const SizedBox(height: WSizes.spaceBtwItems),

                WProfileMenu(
                  title: 'ID người dùng',
                  value: controller.userId,
                  icon: Iconsax.copy,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: controller.userId));
                    Get.snackbar(
                      'Đã sao chép',
                      'ID người dùng đã được sao chép',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  },
                ),
                WProfileMenu(
                  title: 'Số điện thoại',
                  value: controller.phone,
                  icon: Iconsax.copy,
                  onPressed: () {
                    if (controller.phone != 'Chưa cập nhật') {
                      Clipboard.setData(ClipboardData(text: controller.phone));
                      Get.snackbar(
                        'Đã sao chép',
                        'Số điện thoại đã được sao chép',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                      );
                    }
                  },
                ),

                const SizedBox(height: WSizes.spaceBtwItems / 2),
                const Divider(),
                const SizedBox(height: WSizes.spaceBtwItems),

                // Security settings
                // const WSectionHeading(
                //     title: 'Cài đặt bảo mật', showActionButton: false),
                // const SizedBox(height: WSizes.spaceBtwItems),

                // WProfileMenu(
                //   title: 'Đổi mật khẩu',
                //   value: '',
                //   icon: Iconsax.lock,
                //   onPressed: () =>
                //       _showChangePasswordDialog(context, controller),
                // ),

                // const SizedBox(height: WSizes.spaceBtwItems),
                // const Divider(),
                // const SizedBox(height: WSizes.spaceBtwItems),

                // Logout button
                Center(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton.icon(
                      onPressed: () => _showLogoutDialog(context, controller),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red.shade200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Iconsax.logout, size: 20),
                      label: const Text(
                        'Đăng xuất',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: WSizes.spaceBtwItems),
              ],
            ),
          ),
        );
      }),
    );
  }

  // THÊM MỚI - Show avatar options
  void _showAvatarOptions(BuildContext context, ProfileController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ảnh đại diện',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: WColors.primary,
                  ),
            ),
            const SizedBox(height: 20),

            // Change photo option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Iconsax.camera, color: Colors.blue),
              ),
              title: const Text('Thay đổi ảnh'),
              subtitle: const Text('Chọn ảnh mới từ thư viện hoặc chụp ảnh'),
              onTap: () {
                Navigator.pop(context);
                controller.changeProfilePicture();
              },
            ),

            // View full size (if custom avatar exists)
            if (controller.selectedAvatarPath.value.isNotEmpty)
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Iconsax.eye, color: Colors.green),
                ),
                title: const Text('Xem ảnh'),
                subtitle: const Text('Xem ảnh đại diện ở kích thước đầy đủ'),
                onTap: () {
                  Navigator.pop(context);
                  _showAvatarPreview(context, controller);
                },
              ),

            // Remove photo option (if custom avatar exists)
            if (controller.selectedAvatarPath.value.isNotEmpty)
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Iconsax.trash, color: Colors.red),
                ),
                title: const Text('Xóa ảnh'),
                subtitle: const Text('Sử dụng ảnh mặc định'),
                onTap: () {
                  Navigator.pop(context);
                  _showRemoveAvatarDialog(context, controller);
                },
              ),
          ],
        ),
      ),
    );
  }

  // THÊM MỚI - Show avatar preview
  void _showAvatarPreview(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: ClipOval(
                  child: ProfileAvatar(
                    imagePath: controller.currentAvatar,
                    width: 300,
                    height: 300,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // THÊM MỚI - Show remove avatar dialog
  void _showRemoveAvatarDialog(
      BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Xóa ảnh đại diện'),
        content: const Text('Bạn có chắc chắn muốn xóa ảnh đại diện hiện tại?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              controller.removeProfilePicture();
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

  // void _showChangePasswordDialog(
  //     BuildContext context, ProfileController controller) {
  //   final currentPasswordController = TextEditingController();
  //   final newPasswordController = TextEditingController();
  //   final confirmPasswordController = TextEditingController();
  //   bool obscureCurrentPassword = true;
  //   bool obscureNewPassword = true;
  //   bool obscureConfirmPassword = true;

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             title: const Text('Đổi mật khẩu'),
  //             content: SingleChildScrollView(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   // Current Password
  //                   TextField(
  //                     controller: currentPasswordController,
  //                     obscureText: obscureCurrentPassword,
  //                     decoration: InputDecoration(
  //                       labelText: 'Mật khẩu hiện tại',
  //                       border: const OutlineInputBorder(),
  //                       suffixIcon: IconButton(
  //                         icon: Icon(
  //                           obscureCurrentPassword
  //                               ? Iconsax.eye_slash
  //                               : Iconsax.eye,
  //                         ),
  //                         onPressed: () {
  //                           setState(() {
  //                             obscureCurrentPassword = !obscureCurrentPassword;
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 16),

  //                   // New Password
  //                   TextField(
  //                     controller: newPasswordController,
  //                     obscureText: obscureNewPassword,
  //                     decoration: InputDecoration(
  //                       labelText: 'Mật khẩu mới',
  //                       border: const OutlineInputBorder(),
  //                       suffixIcon: IconButton(
  //                         icon: Icon(
  //                           obscureNewPassword
  //                               ? Iconsax.eye_slash
  //                               : Iconsax.eye,
  //                         ),
  //                         onPressed: () {
  //                           setState(() {
  //                             obscureNewPassword = !obscureNewPassword;
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 16),

  //                   // Confirm Password
  //                   TextField(
  //                     controller: confirmPasswordController,
  //                     obscureText: obscureConfirmPassword,
  //                     decoration: InputDecoration(
  //                       labelText: 'Xác nhận mật khẩu mới',
  //                       border: const OutlineInputBorder(),
  //                       suffixIcon: IconButton(
  //                         icon: Icon(
  //                           obscureConfirmPassword
  //                               ? Iconsax.eye_slash
  //                               : Iconsax.eye,
  //                         ),
  //                         onPressed: () {
  //                           setState(() {
  //                             obscureConfirmPassword = !obscureConfirmPassword;
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.of(context).pop(),
  //                 child: const Text('Hủy'),
  //               ),
  //               Obx(() => ElevatedButton(
  //                     onPressed: controller.isChangingPassword.value
  //                         ? null
  //                         : () async {
  //                             await controller.changePassword(
  //                               currentPasswordController.text,
  //                               newPasswordController.text,
  //                               confirmPasswordController.text,
  //                             );
  //                             if (!controller.isChangingPassword.value) {
  //                               Navigator.of(context).pop();
  //                             }
  //                           },
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: WColors.primary,
  //                       foregroundColor: Colors.white,
  //                     ),
  //                     child: controller.isChangingPassword.value
  //                         ? const SizedBox(
  //                             width: 20,
  //                             height: 20,
  //                             child: CircularProgressIndicator(
  //                               strokeWidth: 2,
  //                               valueColor:
  //                                   AlwaysStoppedAnimation<Color>(Colors.white),
  //                             ),
  //                           )
  //                         : const Text('Đổi mật khẩu'),
  //                   )),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  void _showLogoutDialog(BuildContext context, ProfileController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }
}
