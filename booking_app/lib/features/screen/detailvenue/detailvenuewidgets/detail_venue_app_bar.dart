import 'package:booking_app/features/controller/detailvenue_controller.dart';
import 'package:booking_app/features/screen/createpost/createpost_screen.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/helpers/role_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DetailVenueAppBar extends StatelessWidget implements PreferredSizeWidget {
  final DetailVenueController controller;

  const DetailVenueAppBar({
    super.key,
    required this.controller,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: WColors.primary),
          onPressed: () => Get.back(),
          padding: EdgeInsets.zero,
        ),
      ),
      actions: [
        // ✅ Show Edit/Delete buttons for VENDOR/ADMIN
        Obx(() {
          final venue = controller.venue.value;

          if (venue == null) {
            return const SizedBox(width: 8);
          }

          return FutureBuilder<bool>(
            future: _canEditPost(),
            builder: (context, snapshot) {
              // Debug logs
              print(
                  '🔍 AppBar FutureBuilder - ConnectionState: ${snapshot.connectionState}');
              print('🔍 AppBar snapshot.data: ${snapshot.data}');
              print('🔍 Venue ID: ${venue.id}, Vendor ID: ${venue.vendor.id}');

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: WColors.primary,
                      ),
                    ),
                  ),
                );
              }

              if (snapshot.data == true) {
                print('✅ Showing Edit/Delete buttons');
                return Row(
                  children: [
                    // Edit button
                    Container(
                      margin:
                          const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Iconsax.edit, color: WColors.primary),
                        onPressed: _onEditPressed,
                        padding: EdgeInsets.zero,
                        tooltip: 'Chỉnh sửa',
                      ),
                    ),
                    // Delete button
                    Container(
                      margin:
                          const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Iconsax.trash, color: Colors.red),
                        onPressed: _onDeletePressed,
                        padding: EdgeInsets.zero,
                        tooltip: 'Xóa',
                      ),
                    ),
                  ],
                );
              }

              print('❌ Not showing buttons - permission denied');
              return const SizedBox(width: 8);
            },
          );
        }),
        const SizedBox(width: 8),
      ],
    );
  }

  Future<bool> _canEditPost() async {
    final venue = controller.venue.value;
    if (venue == null) {
      print('❌ _canEditPost: venue is null');
      return false;
    }

    final vendorId = venue.vendor.id.toString();
    print('🔍 _canEditPost: Checking permission for vendorId: $vendorId');

    final role = await RoleHelper.getCurrentRole();
    print('🔍 Current user role: $role');

    final canEdit = await RoleHelper.canEditPost(vendorId);
    print('🔍 Can edit result: $canEdit');

    return canEdit;
  }

  void _onEditPressed() async {
    final venue = controller.venue.value;
    if (venue == null) return;

    // Navigate to CreatePostScreen in edit mode
    final result = await Get.to(
      () => const CreatePostScreen(),
      arguments: {
        'venue': venue,
      },
    );

    // If edit was successful, reload the venue details
    if (result == true) {
      controller.loadVenueDetails(venue.id.toString());
    }
  }

  void _onDeletePressed() {
    final venue = controller.venue.value;
    if (venue == null) return;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Iconsax.warning_2, color: Colors.red),
            SizedBox(width: 12),
            Text('Xác nhận xóa'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bạn có chắc chắn muốn xóa bài viết này?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    venue.location,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Hành động này không thể hoàn tác!',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Hủy', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteVenue();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Xóa bài viết'),
          ),
        ],
      ),
    );
  }
}
