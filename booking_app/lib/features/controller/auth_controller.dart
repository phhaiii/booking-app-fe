import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/service/api.dart';
import 'package:booking_app/service/storage_service.dart';
import 'package:booking_app/models/api_response.dart';
import 'package:booking_app/models/auth_response.dart';
import 'package:booking_app/models/login_request.dart';

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
      // TODO: Navigate to home screen
      // Get.offAllNamed('/home');
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
        duration: Duration(seconds: 2),
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

      // Call API
      final response = await ApiService.post(
        '/auth/login',
        body: loginRequest.toJson(),
      );

      // Parse response theo cấu trúc ApiResponse<AuthResponse>
      final apiResponse = ApiResponse<AuthResponse>.fromJson(
        response,
        (data) => AuthResponse.fromJson(data),
      );

      if (apiResponse.success && apiResponse.data != null) {
        authResponse.value = apiResponse.data;

        // Lưu token và thông tin user
        await StorageService.saveToken(apiResponse.data!.accessToken);
        await StorageService.saveRefreshToken(apiResponse.data!.refreshToken);
        await StorageService.saveUserId(apiResponse.data!.user.id.toString());
        await StorageService.saveEmail(apiResponse.data!.user.email);
        await StorageService.saveUserData(apiResponse.data!.user.toJson());

        Get.snackbar(
          'Thành công',
          apiResponse.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          duration: Duration(seconds: 2),
        );

        // Clear controllers
        emailController.clear();
        passwordController.clear();

        // Navigate to home screen sau 1 giây
        await Future.delayed(Duration(seconds: 1));
        // TODO: Thay đổi route phù hợp với app của bạn
        // Get.offAllNamed('/home');
        print('Login success - Navigate to home');
      } else {
        Get.snackbar(
          'Lỗi',
          apiResponse.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      String errorMessage = 'Đã có lỗi xảy ra';

      if (e.toString().contains('Exception:')) {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      } else if (e.toString().contains('SocketException')) {
        errorMessage =
            'Không thể kết nối tới server. Vui lòng kiểm tra kết nối mạng';
      }

      Get.snackbar(
        'Lỗi đăng nhập',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: Duration(seconds: 3),
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
        // Call logout API
        await ApiService.postWithAuth(
          '/auth/logout',
          body: {},
          token: token,
        );
      }

      // Clear all stored data
      await StorageService.clearAll();
      authResponse.value = null;

      Get.snackbar(
        'Thành công',
        'Đăng xuất thành công',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );

      // Navigate to login
      Get.offAllNamed('/login');
    } catch (e) {
      // Vẫn logout local nếu API fail
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
      final refreshToken = await StorageService.getRefreshToken();
      if (refreshToken == null) return false;

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
        return true;
      }
      return false;
    } catch (e) {
      print('Refresh token error: $e');
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
