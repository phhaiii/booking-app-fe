import 'package:booking_app/service/storage_service.dart';

class RoleHelper {
  // Role constants
  static const String ROLE_USER = 'USER';
  static const String ROLE_VENDOR = 'VENDOR';
  static const String ROLE_ADMIN = 'ADMIN';

  // ✅ Get current user role
  static Future<String> getCurrentRole() async {
    final role = await StorageService.getUserRole() ?? ROLE_USER;
    print('🔐 RoleHelper.getCurrentRole: $role');
    return role;
  }

  // ✅ Check if user is USER
  static Future<bool> isUser() async {
    final role = await getCurrentRole();
    return role == ROLE_USER;
  }

  // ✅ Check if user is VENDOR
  static Future<bool> isVendor() async {
    final role = await getCurrentRole();
    return role == ROLE_VENDOR;
  }

  // ✅ Check if user is ADMIN
  static Future<bool> isAdmin() async {
    final role = await getCurrentRole();
    return role == ROLE_ADMIN;
  }

  // ✅ Check if user has any of the roles
  static Future<bool> hasAnyRole(List<String> roles) async {
    final currentRole = await getCurrentRole();
    return roles.contains(currentRole);
  }

  // ═══════════════════════════════════════════════
  // 🔒 PERMISSION CHECKS
  // ═══════════════════════════════════════════════

  // ✅ Can create post?
  static Future<bool> canCreatePost() async {
    return await hasAnyRole([ROLE_VENDOR, ROLE_ADMIN]);
  }

  // ✅ Can edit post?
  static Future<bool> canEditPost(String postOwnerId) async {
    final role = await getCurrentRole();
    print('🔐 RoleHelper.canEditPost - Role: $role, PostOwnerId: $postOwnerId');

    if (role == ROLE_ADMIN) {
      print('✅ ADMIN can edit any post');
      return true; // Admin can edit any post
    }

    if (role == ROLE_VENDOR) {
      final userId = await StorageService.getUserId();
      print('🔐 VENDOR check - UserId: $userId, PostOwnerId: $postOwnerId');
      final canEdit = userId == postOwnerId;
      print('🔐 VENDOR can edit: $canEdit');
      return canEdit; // Vendor can edit own posts
    }

    print('❌ USER cannot edit posts');
    return false; // USER cannot edit posts
  }

  // ✅ Can delete post?
  static Future<bool> canDeletePost(String postOwnerId) async {
    return await canEditPost(postOwnerId); // Same logic as edit
  }

  // ✅ Can create booking?
  static Future<bool> canCreateBooking() async {
    return await hasAnyRole([ROLE_USER, ROLE_ADMIN]);
  }

  // ✅ Can manage bookings (vendor side)?
  static Future<bool> canManageBookings() async {
    return await hasAnyRole([ROLE_VENDOR, ROLE_ADMIN]);
  }

  // ✅ Can view admin panel?
  static Future<bool> canViewAdminPanel() async {
    return await isAdmin();
  }

  // ✅ Can manage users?
  static Future<bool> canManageUsers() async {
    return await isAdmin();
  }

  // ✅ Can approve/reject posts?
  static Future<bool> canModerate() async {
    return await isAdmin();
  }

  // ═══════════════════════════════════════════════
  // 🎨 UI HELPERS
  // ═══════════════════════════════════════════════

  // ✅ Get role display name
  static Future<String> getRoleDisplayName() async {
    final role = await getCurrentRole();
    switch (role) {
      case ROLE_ADMIN:
        return 'Quản trị viên';
      case ROLE_VENDOR:
        return 'Nhà cung cấp';
      case ROLE_USER:
      default:
        return 'Người dùng';
    }
  }
}
