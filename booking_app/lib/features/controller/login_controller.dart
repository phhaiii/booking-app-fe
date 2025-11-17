import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/service/api.dart';
import 'package:booking_app/service/storage_service.dart';
import 'package:booking_app/navigation_menu.dart';
import 'package:booking_app/response/api_response.dart';
import 'package:booking_app/response/auth_response.dart';
import 'package:booking_app/request/login_request.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final rememberMe = false.obs;

  // User data
  final Rx<AuthResponse?> authResponse = Rx<AuthResponse?>(null);

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  // Kiểm tra trạng thái đăng nhập khi khởi động app
  Future<void> checkLoginStatus() async {
    final isLoggedIn = await StorageService.isLoggedIn();
    if (isLoggedIn) {
      // TODO: Navigate to home screen based on role
      final role = await StorageService.getUserRole();
      print('🔐 User already logged in - Role: $role');
      // Get.offAll(() => NavigationMenu());
    }
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Toggle remember me
  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  // Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  // Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  // ✅ Helper: Extract role from user response
  String _getUserRole(dynamic user) {
    print('🔍 _getUserRole called');
    print('   user.role = ${user.role}');
    print('   user.role.runtimeType = ${user.role?.runtimeType}');

    // Try different possible structures
    if (user.role != null) {
      // If role is an object with 'name' property
      if (user.role is Map) {
        final roleName = user.role['name']?.toString() ?? 'USER';
        print('   ✅ Extracted from Map: $roleName');
        return roleName;
      }
      // If role has a 'name' getter
      try {
        final roleName = user.role.name?.toString() ?? 'USER';
        print('   ✅ Extracted from object.name: $roleName');
        return roleName;
      } catch (e) {
        print('   ⚠️ Error accessing .name: $e');
        // If role is a direct string
        final roleName = user.role.toString();
        print('   ✅ Using toString(): $roleName');
        return roleName;
      }
    }
    print('   ⚠️ user.role is null, returning default USER');
    return 'USER'; // Default role
  }

  // ✅ Helper: Extract phone from user response
  String? _getUserPhone(dynamic user) {
    // Try different possible field names
    try {
      return user.phoneNumber?.toString() ??
          user.phone?.toString() ??
          user.phoneNo?.toString();
    } catch (e) {
      return null;
    }
  }

  // Login function
  Future<void> login() async {
    // Validate inputs
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng nhập đầy đủ thông tin',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      isLoading.value = true;

      // Tạo LoginRequest
      final loginRequest = LoginRequest(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      print('📤 Sending login request for: ${loginRequest.email}');

      // Call API
      final response = await ApiService.postNoAuth(
        '/auth/login',
        body: loginRequest.toJson(),
      );

      print('📥 Login response received');
      print('🔍 Raw response: $response');

      // Parse response theo cấu trúc ApiResponse<AuthResponse>
      final apiResponse = ApiResponse<AuthResponse>.fromJson(
        response,
        (data) => AuthResponse.fromJson(data),
      );

      if (apiResponse.success && apiResponse.data != null) {
        authResponse.value = apiResponse.data;
        final user = apiResponse.data!.user;

        print('🔍 User object from API: ${user.toJson()}');

        // ✅ Extract role safely
        final userRole = _getUserRole(user);

        // ✅ Extract phone safely
        final userPhone = _getUserPhone(user);

        print('👤 User data:');
        print('   - ID: ${user.id}');
        print('   - Email: ${user.email}');
        print('   - Name: ${user.fullName}');
        print('   - Role: $userRole');
        print('   - Phone: ${userPhone ?? "N/A"}');

        // ✅ Save tokens
        await StorageService.saveToken(apiResponse.data!.accessToken);
        await StorageService.saveRefreshToken(apiResponse.data!.refreshToken);

        // ✅ Save user data với safe field access
        print('🔐 About to save user data with role: "$userRole"');
        await StorageService.saveUserData(
          userId: user.id.toString(),
          email: user.email,
          role: userRole,
          fullName: user.fullName,
          phone: userPhone,
          // avatarUrl: user.avatar, // Uncomment if needed
        );

        print('✅ User data saved successfully');

        Get.snackbar(
          'Thành công',
          'Chào mừng ${user.fullName}!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 2),
          icon: const Icon(Icons.check_circle, color: Colors.green),
        );

        // Clear controllers
        emailController.clear();
        passwordController.clear();

        // Navigate to home screen
        Get.offAll(() => NavigationMenu());

        print('✅ Login success - Role: $userRole');
      } else {
        print('❌ Login failed: ${apiResponse.message}');

        Get.snackbar(
          'Lỗi',
          apiResponse.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.error_outline, color: Colors.red),
        );
      }
    } catch (e) {
      print('❌ Login error: $e');

      String errorMessage = 'Đã có lỗi xảy ra';

      if (e.toString().contains('Exception:')) {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      } else if (e.toString().contains('SocketException')) {
        errorMessage =
            'Không thể kết nối tới server. Vui lòng kiểm tra kết nối mạng';
      } else if (e.toString().contains('FormatException')) {
        errorMessage = 'Dữ liệu trả về không hợp lệ';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Kết nối quá lâu, vui lòng thử lại';
      }

      Get.snackbar(
        'Lỗi đăng nhập',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout function
  Future<void> logout() async {
    try {
      isLoading.value = true;

      final token = await StorageService.getToken();
      if (token != null) {
        try {
          // Call logout API
          await ApiService.postWithAuth(
            '/auth/logout',
            body: {},
            token: token,
          );
          print('✅ Logout API called successfully');
        } catch (e) {
          print('⚠️ Logout API failed, but continuing local logout: $e');
        }
      }

      // Clear all stored data
      await StorageService.clearAll();
      authResponse.value = null;

      print('✅ All data cleared');

      Get.snackbar(
        'Thành công',
        'Đăng xuất thành công',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        icon: const Icon(Icons.check_circle, color: Colors.green),
      );

      // Navigate to login
      Get.offAllNamed('/login');
    } catch (e) {
      print('❌ Logout error: $e');

      // Vẫn logout local nếu có lỗi
      await StorageService.clearAll();
      authResponse.value = null;
      Get.offAllNamed('/login');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh token
  Future<bool> refreshToken() async {
    try {
      print('🔄 Refreshing token...');

      final refreshToken = await StorageService.getRefreshToken();
      if (refreshToken == null) {
        print('❌ No refresh token found');
        return false;
      }

      final response = await ApiService.post(
        '/auth/refresh-token',
        body: {'refreshToken': refreshToken},
      );

      final apiResponse = ApiResponse<AuthResponse>.fromJson(
        response,
        (data) => AuthResponse.fromJson(data),
      );

      if (apiResponse.success && apiResponse.data != null) {
        // Cập nhật tokens mới
        await StorageService.saveToken(apiResponse.data!.accessToken);
        await StorageService.saveRefreshToken(apiResponse.data!.refreshToken);
        authResponse.value = apiResponse.data;

        print('✅ Token refreshed successfully');
        return true;
      }

      print('❌ Token refresh failed');
      return false;
    } catch (e) {
      print('❌ Refresh token error: $e');
      return false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
