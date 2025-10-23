import 'package:booking_app/common/section_heading.dart';
import 'package:booking_app/features/controller/profile_controller.dart';
import 'package:booking_app/features/screen/profile/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/common/circularImage.dart';
import 'package:booking_app/utils/constants/image_strings.dart';
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
                // Profile picture
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      const WCircularImage(
                          image: WImages.splash, width: 80, height: 80),
                      TextButton(
                          onPressed: () {},
                          child: const Text('Thay đổi ảnh đại diện',
                              style: TextStyle(color: WColors.primary))),
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
                WProfileMenu(
                  title: 'Địa chỉ',
                  value: controller.address,
                  onPressed: () {},
                ),
                WProfileMenu(
                  title: 'Ngày sinh',
                  value: controller.formattedDateOfBirth,
                  onPressed: () {},
                ),

                const SizedBox(height: WSizes.spaceBtwItems / 2),
                const Divider(),
                const SizedBox(height: WSizes.spaceBtwItems),

                // Security settings
                const WSectionHeading(
                    title: 'Cài đặt bảo mật', showActionButton: false),
                const SizedBox(height: WSizes.spaceBtwItems),

                WProfileMenu(
                  title: 'Đổi mật khẩu',
                  value: '',
                  icon: Iconsax.lock,
                  onPressed: () => _showChangePasswordDialog(context, controller),
                ),

                const SizedBox(height: WSizes.spaceBtwItems),
                const Divider(),
                const SizedBox(height: WSizes.spaceBtwItems),

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

  void _showChangePasswordDialog(BuildContext context, ProfileController controller) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureCurrentPassword = true;
    bool obscureNewPassword = true;
    bool obscureConfirmPassword = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Đổi mật khẩu'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Current Password
                    TextField(
                      controller: currentPasswordController,
                      obscureText: obscureCurrentPassword,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu hiện tại',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureCurrentPassword ? Iconsax.eye_slash : Iconsax.eye,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureCurrentPassword = !obscureCurrentPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // New Password
                    TextField(
                      controller: newPasswordController,
                      obscureText: obscureNewPassword,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu mới',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureNewPassword ? Iconsax.eye_slash : Iconsax.eye,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureNewPassword = !obscureNewPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Xác nhận mật khẩu mới',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword ? Iconsax.eye_slash : Iconsax.eye,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Hủy'),
                ),
                Obx(() => ElevatedButton(
                  onPressed: controller.isChangingPassword.value
                      ? null
                      : () async {
                          await controller.changePassword(
                            currentPasswordController.text,
                            newPasswordController.text,
                            confirmPasswordController.text,
                          );
                          if (!controller.isChangingPassword.value) {
                            Navigator.of(context).pop();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: controller.isChangingPassword.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Đổi mật khẩu'),
                )),
              ],
            );
          },
        );
      },
    );
  }

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