import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/service/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  // Observables
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final token = ''.obs;
  final user = Rxn<Map<String, dynamic>>();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  // Check if user is already logged in
  Future<void> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('token');
      
      if (savedToken != null && savedToken.isNotEmpty) {
        token.value = savedToken;
        isLoggedIn.value = true;
        // Optionally validate token with backend
      }
    } catch (e) {
      print('Error checking login status: $e');
    }
  }

  // Login function
  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      final result = await ApiService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (result['success']) {
        // Save token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', result['token']);
        
        token.value = result['token'];
        user.value = result['user'];
        isLoggedIn.value = true;

        Get.snackbar(
          'Success',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to home screen
        Get.offAllNamed('/home');
      } else {
        Get.snackbar(
          'Login Failed',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Register function
  Future<void> register() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      final result = await ApiService.register(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        phone: phoneController.text.trim(),
      );

      if (result['success']) {
        Get.snackbar(
          'Success',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to login screen
        Get.offNamed('/login');
      } else {
        Get.snackbar(
          'Registration Failed',
          result['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout function
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      
      token.value = '';
      user.value = null;
      isLoggedIn.value = false;
      
      // Clear form controllers
      emailController.clear();
      passwordController.clear();
      firstNameController.clear();
      lastNameController.clear();
      phoneController.clear();

      Get.offAllNamed('/login');
    } catch (e) {
      print('Logout error: $e');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}