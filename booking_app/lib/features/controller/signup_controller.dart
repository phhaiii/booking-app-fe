import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/service/api.dart';
import 'package:booking_app/service/storage_service.dart';
import 'package:booking_app/navigation_menu.dart';
import 'package:booking_app/models/auth_response.dart';
import 'package:booking_app/models/register_request.dart';
import 'dart:convert';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // Form key
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  // Form controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController(); 
  final addressController = TextEditingController();
  final dateOfBirthController = TextEditingController();

  // Observable variables
  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs; 
  final termsAccepted = false.obs;
  final selectedDate = Rx<DateTime?>(null);

  // User data
  final Rx<AuthResponse?> authResponse = Rx<AuthResponse?>(null);

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Toggle confirm password visibility - THÊM MỚI
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  // Toggle terms acceptance
  void toggleTermsAcceptance(bool? value) {
    termsAccepted.value = value ?? false;
  }

  // Select date of birth
  Future<void> selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now()
          .subtract(const Duration(days: 365 * 13)), // Ít nhất 13 tuổi
      helpText: 'Chọn ngày sinh',
      cancelText: 'Hủy',
      confirmText: 'Chọn',
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      dateOfBirthController.text = _formatDate(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateForApi(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Validate first name
  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập họ';
    }
    if (value.trim().length < 2) {
      return 'Họ phải có ít nhất 2 ký tự';
    }
    return null;
  }

  // Validate last name
  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập tên';
    }
    if (value.trim().length < 2) {
      return 'Tên phải có ít nhất 2 ký tự';
    }
    return null;
  }

  // Validate email
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập email';
    }
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  // Validate phone - theo pattern backend
  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }

    String phone = value.trim();

    // Kiểm tra theo pattern backend: ^(0|\\+84)[0-9]{9,10}$
    if (!RegExp(r'^(0|\+84)[0-9]{9,10}$').hasMatch(phone)) {
      return 'Số điện thoại không hợp lệ (VD: 0987654321 hoặc +84987654321)';
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

  // Validate confirm password - THÊM MỚI
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }
    if (value != passwordController.text) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  // Validate address
  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập địa chỉ';
    }
    if (value.trim().length > 255) {
      return 'Địa chỉ không được quá 255 ký tự';
    }
    return null;
  }

  // Validate date of birth
  String? validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng chọn ngày sinh';
    }
    if (selectedDate.value == null) {
      return 'Vui lòng chọn ngày sinh';
    }

    // Kiểm tra tuổi tối thiểu 13
    final now = DateTime.now();
    final age = now.difference(selectedDate.value!).inDays / 365;
    if (age < 13) {
      return 'Bạn phải từ 13 tuổi trở lên';
    }

    return null;
  }

  // Signup function
  Future<void> signup() async {
    print('Starting signup process...');

    // Validate form
    if (!signupFormKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    // Check terms acceptance
    if (!termsAccepted.value) {
      print('Terms not accepted');
      Get.snackbar(
        'Lỗi',
        'Vui lòng đồng ý với điều khoản sử dụng',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.transparent,
        colorText: Colors.red,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      isLoading.value = true;
      print('Setting loading state to true');

      // Prepare data according to backend requirements
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final fullName = '$firstName $lastName'.trim();
      final email = emailController.text.trim().toLowerCase();
      final phone = phoneController.text.trim();
      final password = passwordController.text;
      final address = addressController.text.trim();
      final dateOfBirth = selectedDate.value != null
          ? _formatDateForApi(selectedDate.value!)
          : '';

      print('Prepared data:');
      print('FullName: $fullName');
      print('Email: $email');
      print('Phone: $phone');
      print('Address: $address');
      print('DateOfBirth: $dateOfBirth');

      // Validate fullName length according to backend
      if (fullName.isEmpty || fullName.length > 100) {
        throw Exception('Họ tên không được để trống và không quá 100 ký tự');
      }

      // Create RegisterRequest
      final registerRequest = RegisterRequest(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        address: address,
        dateOfBirth: dateOfBirth,
      );

      print('Sending registration request: ${registerRequest.toJson()}');
      // Call API
      final response = await ApiService.postNoAuth(
        '/auth/register',
        body: registerRequest.toJson(),
      );

      print('Registration response received: $response');

      // Check if response is null or empty
      if (response == null) {
        throw Exception('Server không phản hồi');
      }

      // Parse response
      Map<String, dynamic> responseMap;
      if (response is String) {
        responseMap = jsonDecode(response);
      } else if (response is Map<String, dynamic>) {
        responseMap = response;
      } else {
        throw Exception('Định dạng phản hồi không hợp lệ');
      }

      print('Parsed response: $responseMap');

      final success = responseMap['success'] ?? false;
      final message = responseMap['message'] ?? '';
      final data = responseMap['data'];

      if (success && data != null) {
        // Extract and save user data
        final accessToken = data['accessToken'] ?? '';
        final refreshToken = data['refreshToken'] ?? '';
        final userData = data['user'] ?? {};

        if (accessToken.isEmpty || refreshToken.isEmpty) {
          throw Exception('Token không hợp lệ từ server');
        }

        await StorageService.saveToken(accessToken);
        await StorageService.saveRefreshToken(refreshToken);

        if (userData['id'] != null) {
          await StorageService.saveUserId(userData['id'].toString());
        }
        if (userData['email'] != null) {
          await StorageService.saveEmail(userData['email'].toString());
        }

        await StorageService.saveUserData(userData);

        print('User data saved successfully');

        Get.snackbar(
          'Thành công',
          'Đăng ký tài khoản thành công!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.transparent,
          colorText: Colors.green,
          duration: const Duration(seconds: 2),
        );

        // Clear controllers
        _clearControllers();

        // Navigate to home screen
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAll(() => NavigationMenu());

        print('🎉 Signup completed successfully!');
      } else {
        throw Exception(message.isNotEmpty ? message : 'Đăng ký thất bại');
      }
    } catch (e) {
      print('Signup error occurred: $e');

      String errorMessage = 'Đã có lỗi xảy ra';

      if (e.toString().contains('Exception:')) {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      } else if (e.toString().contains('email already exists')) {
        errorMessage = 'Email này đã được sử dụng';
      } else if (e.toString().contains('phone already exists')) {
        errorMessage = 'Số điện thoại này đã được sử dụng';
      } else if (e.toString().contains('SocketException')) {
        errorMessage = 'Không thể kết nối tới server';
      }

      Get.snackbar(
        'Lỗi đăng ký',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.transparent,
        colorText: Colors.red,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _clearControllers() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear(); 
    addressController.clear();
    dateOfBirthController.clear();
    selectedDate.value = null;
    termsAccepted.value = false;
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose(); 
    addressController.dispose();
    dateOfBirthController.dispose();
    super.onClose();
  }
}
