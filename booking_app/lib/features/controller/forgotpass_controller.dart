import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class ForgotPasswordController extends GetxController {
  // Text Controllers
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final List<TextEditingController> otpControllers = 
      List.generate(6, (index) => TextEditingController());

  // Observables
  var currentStep = 1.obs;
  var isLoading = false.obs;
  var obscureNewPassword = true.obs;
  var obscureConfirmPassword = true.obs;
  var canResendOTP = false.obs;
  var resendCountdown = 60.obs;

  Timer? _resendTimer;

  @override
  void onClose() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    _resendTimer?.cancel();
    super.onClose();
  }

  // Step 1: Send OTP
  Future<void> sendOTP() async {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng nhập email',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar(
        'Lỗi',
        'Email không hợp lệ',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate success
      currentStep.value = 2;
      _startResendTimer();
      
      Get.snackbar(
        'Thành công',
        'Mã xác nhận đã được gửi đến ${emailController.text}',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Có lỗi xảy ra. Vui lòng thử lại.',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Step 2: Verify OTP
  Future<void> verifyOTP() async {
    String otp = otpControllers.map((controller) => controller.text).join();
    
    if (otp.length != 6) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng nhập đầy đủ mã OTP',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate success (check if OTP is correct)
      if (otp == '123456') { // Demo OTP
        currentStep.value = 3;
        _resendTimer?.cancel();
        
        Get.snackbar(
          'Thành công',
          'Mã xác nhận đúng',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Lỗi',
          'Mã OTP không đúng',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Có lỗi xảy ra. Vui lòng thử lại.',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Step 3: Reset Password
  Future<void> resetPassword() async {
    if (newPasswordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng nhập đầy đủ thông tin',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Lỗi',
        'Mật khẩu xác nhận không khớp',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!_isPasswordValid(newPasswordController.text)) {
      Get.snackbar(
        'Lỗi',
        'Mật khẩu không đáp ứng yêu cầu',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Success
      Get.snackbar(
        'Thành công',
        'Mật khẩu đã được cập nhật thành công',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      // Navigate back to login after delay
      Future.delayed(const Duration(seconds: 2), () {
        Get.back(); // Go back to login screen
      });
      
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Có lỗi xảy ra. Vui lòng thử lại.',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Resend OTP
  Future<void> resendOTP() async {
    if (!canResendOTP.value) return;

    isLoading.value = true;
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Clear OTP fields
      for (var controller in otpControllers) {
        controller.clear();
      }
      
      _startResendTimer();
      
      Get.snackbar(
        'Thành công',
        'Mã xác nhận mới đã được gửi',
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Có lỗi xảy ra. Vui lòng thử lại.',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Navigation
  void goToPreviousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
      if (currentStep.value == 2) {
        _startResendTimer();
      }
    }
  }

  // Toggle password visibility
  void toggleNewPasswordVisibility() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  // Helper methods
  void _startResendTimer() {
    canResendOTP.value = false;
    resendCountdown.value = 60;
    
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown.value > 0) {
        resendCountdown.value--;
      } else {
        canResendOTP.value = true;
        timer.cancel();
      }
    });
  }

  bool _isPasswordValid(String password) {
    // At least 8 characters
    if (password.length < 8) return false;
    
    // At least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    
    // At least one digit
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    
    // At least one special character
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    
    return true;
  }
}