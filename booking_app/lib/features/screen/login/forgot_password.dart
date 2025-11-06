import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/utils/constants/image_strings.dart';
import 'package:booking_app/common/splash/circularImage.dart';
import 'package:booking_app/features/controller/forgotpass_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quên mật khẩu',
          style: TextStyle(color: WColors.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: WColors.primary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(WSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Image & Text
              _buildHeader(),
              const SizedBox(height: WSizes.spaceBtwSections),

              // Step Indicator
              _buildStepIndicator(controller),
              const SizedBox(height: WSizes.spaceBtwSections),

              // Content based on current step
              _buildStepContent(controller),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const WCircularImage(
          image: WImages.splash,
          width: 100,
          height: 100,
        ),
        const SizedBox(height: WSizes.spaceBtwItems),
        Text(
          'Khôi phục mật khẩu',
          style: Theme.of(Get.context!).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: WColors.primary,
          ),
        ),
        const SizedBox(height: WSizes.spaceBtwItems / 2),
        Text(
          'Nhập thông tin của bạn để khôi phục mật khẩu',
          style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStepIndicator(ForgotPasswordController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: WColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          _buildStep(1, 'Email', controller.currentStep.value >= 1),
          _buildStepConnector(controller.currentStep.value >= 2),
          _buildStep(2, 'OTP', controller.currentStep.value >= 2),
          _buildStepConnector(controller.currentStep.value >= 3),
          _buildStep(3, 'Mật khẩu mới', controller.currentStep.value >= 3),
        ],
      ),
    );
  }

  Widget _buildStep(int stepNumber, String title, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isActive ? WColors.primary : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? WColors.primary : Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Container(
      width: 24,
      height: 2,
      color: isActive ? WColors.primary : Colors.grey.shade300,
      margin: const EdgeInsets.only(bottom: 20),
    );
  }

  Widget _buildStepContent(ForgotPasswordController controller) {
    switch (controller.currentStep.value) {
      case 1:
        return _buildEmailStep(controller);
      case 2:
        return _buildOTPStep(controller);
      case 3:
        return _buildNewPasswordStep(controller);
      default:
        return _buildEmailStep(controller);
    }
  }

  Widget _buildEmailStep(ForgotPasswordController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.sms,
                color: WColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Nhập địa chỉ email',
                style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: WColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: WSizes.spaceBtwItems),
          
          Text(
            'Chúng tôi sẽ gửi mã xác nhận đến email của bạn',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: WSizes.spaceBtwItems),

          TextFormField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email *',
              hintText: 'Nhập địa chỉ email của bạn',
              prefixIcon: const Icon(Iconsax.sms),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: WColors.primary),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập email';
              }
              if (!GetUtils.isEmail(value)) {
                return 'Email không hợp lệ';
              }
              return null;
            },
          ),
          
          const SizedBox(height: WSizes.spaceBtwSections),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.sendOTP(),
              style: ElevatedButton.styleFrom(
                backgroundColor: WColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: controller.isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Iconsax.send_1, size: 20),
              label: Text(
                controller.isLoading.value ? 'Đang gửi...' : 'Gửi mã xác nhận',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOTPStep(ForgotPasswordController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.shield_tick,
                color: WColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Xác nhận mã OTP',
                style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: WColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: WSizes.spaceBtwItems),
          
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
              children: [
                const TextSpan(text: 'Mã xác nhận đã được gửi đến '),
                TextSpan(
                  text: controller.emailController.text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: WColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: WSizes.spaceBtwItems),

          // OTP Input Fields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              return SizedBox(
                width: 45,
                height: 60,
                child: TextFormField(
                  controller: controller.otpControllers[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: WColors.primary, width: 2),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.length == 1 && index < 5) {
                      FocusScope.of(Get.context!).nextFocus();
                    } else if (value.isEmpty && index > 0) {
                      FocusScope.of(Get.context!).previousFocus();
                    }
                  },
                ),
              );
            }),
          ),

          const SizedBox(height: WSizes.spaceBtwItems),

          // Resend OTP
          Center(
            child: Obx(() => controller.canResendOTP.value
                ? TextButton(
                    onPressed: () => controller.resendOTP(),
                    child: const Text(
                      'Gửi lại mã',
                      style: TextStyle(
                        color: WColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Text(
                    'Gửi lại sau ${controller.resendCountdown.value}s',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  )),
          ),

          const SizedBox(height: WSizes.spaceBtwSections),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.verifyOTP(),
              style: ElevatedButton.styleFrom(
                backgroundColor: WColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: controller.isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Iconsax.verify, size: 20),
              label: Text(
                controller.isLoading.value ? 'Đang xác nhận...' : 'Xác nhận',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: WSizes.spaceBtwItems),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => controller.goToPreviousStep(),
              style: OutlinedButton.styleFrom(
                foregroundColor: WColors.primary,
                side: const BorderSide(color: WColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Iconsax.arrow_left, size: 20),
              label: const Text(
                'Quay lại',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewPasswordStep(ForgotPasswordController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.lock,
                color: WColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Tạo mật khẩu mới',
                style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: WColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: WSizes.spaceBtwItems),
          
          Text(
            'Tạo mật khẩu mới an toàn cho tài khoản của bạn',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: WSizes.spaceBtwItems),

          // New Password
          Obx(() => TextFormField(
            controller: controller.newPasswordController,
            obscureText: controller.obscureNewPassword.value,
            decoration: InputDecoration(
              labelText: 'Mật khẩu mới *',
              hintText: 'Nhập mật khẩu mới',
              prefixIcon: const Icon(Iconsax.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.obscureNewPassword.value
                      ? Iconsax.eye_slash
                      : Iconsax.eye,
                ),
                onPressed: () => controller.toggleNewPasswordVisibility(),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: WColors.primary),
              ),
            ),
          )),

          const SizedBox(height: WSizes.spaceBtwItems),

          // Confirm Password
          Obx(() => TextFormField(
            controller: controller.confirmPasswordController,
            obscureText: controller.obscureConfirmPassword.value,
            decoration: InputDecoration(
              labelText: 'Xác nhận mật khẩu *',
              hintText: 'Nhập lại mật khẩu mới',
              prefixIcon: const Icon(Iconsax.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.obscureConfirmPassword.value
                      ? Iconsax.eye_slash
                      : Iconsax.eye,
                ),
                onPressed: () => controller.toggleConfirmPasswordVisibility(),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: WColors.primary),
              ),
            ),
          )),

          const SizedBox(height: WSizes.spaceBtwItems),

          // Password Requirements
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yêu cầu mật khẩu:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                _buildPasswordRequirement('Ít nhất 8 ký tự'),
                _buildPasswordRequirement('Có ít nhất 1 chữ hoa'),
                _buildPasswordRequirement('Có ít nhất 1 chữ số'),
                _buildPasswordRequirement('Có ít nhất 1 ký tự đặc biệt'),
              ],
            ),
          ),

          const SizedBox(height: WSizes.spaceBtwSections),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.resetPassword(),
              style: ElevatedButton.styleFrom(
                backgroundColor: WColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: controller.isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Iconsax.tick_circle, size: 20),
              label: Text(
                controller.isLoading.value ? 'Đang cập nhật...' : 'Hoàn thành',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: WSizes.spaceBtwItems),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => controller.goToPreviousStep(),
              style: OutlinedButton.styleFrom(
                foregroundColor: WColors.primary,
                side: const BorderSide(color: WColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Iconsax.arrow_left, size: 20),
              label: const Text(
                'Quay lại',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirement(String requirement) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            Iconsax.tick_circle,
            size: 16,
            color: Colors.blue.shade600,
          ),
          const SizedBox(width: 8),
          Text(
            requirement,
            style: TextStyle(
              color: Colors.blue.shade600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}