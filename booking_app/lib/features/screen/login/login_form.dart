import 'package:booking_app/features/screen/signup/signup.dart';
import 'package:booking_app/features/controller/login_controller.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/text_strings.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:booking_app/features/screen/login/forgot_password.dart';
class WLoginForm extends StatelessWidget {
  const WLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: WSizes.spaceBtwSections),
        child: Column(
          children: [
            // Email
            TextFormField(
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                label: Text(WTexts.email),
                hintText: WTexts.hintEmail,
              ),
              validator: controller.validateEmail,
            ),
            const SizedBox(height: WSizes.spaceBtwInputFields),
            // Password
            Obx(
              () => TextFormField(
                controller: controller.passwordController,
                obscureText: controller.isPasswordHidden.value,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  label: Text(WTexts.password),
                  hintText: WTexts.hintPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordHidden.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
                validator: controller.validatePassword,
              ),
            ),
            const SizedBox(height: WSizes.spaceBtwInputFields / 2),
            // Remember me and forgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remember me
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: controller.rememberMe.value,
                        onChanged: controller.toggleRememberMe,
                      ),
                    ),
                    const Text(WTexts.rememberMe),
                  ],
                ),
                // Forgot password
                TextButton(
                  onPressed: () => Get.to(() => const ForgotPasswordScreen()),
                  child: Text(WTexts.forgetPassword, style: TextStyle(color: WColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: WSizes.spaceBtwSections),
            // Sign in button with loading state
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
//                   onPressed: () => Get.to(() => const DashboardScreen()),
//                   child: const Text(WTexts.signIn),
//                 )),
                  onPressed:
                      controller.isLoading.value ? null : controller.login,
                      child: controller.isLoading.value
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(WTexts.signIn),
                ),
              ),
            ),
            const SizedBox(height: WSizes.spaceBtwItems),
            // Create Account
            SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.to(() => const SignupScreen()),
                  child: const Text(WTexts.createAccount),
                )),
          ],
        ),
      ),
    );
  }
}
