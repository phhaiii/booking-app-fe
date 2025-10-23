import 'package:booking_app/features/controller/signup_controller.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/utils/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = WHelpersFunctions.isDarkMode(context);
    final controller = Get.find<SignupController>();

    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          // First Name & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstNameController,
                  validator: controller.validateFirstName,
                  decoration: const InputDecoration(
                    labelText: 'Họ',
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(width: WSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: controller.lastNameController,
                  validator: controller.validateLastName,
                  decoration: const InputDecoration(
                    labelText: 'Tên',
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: WSizes.spaceBtwInputFields),

          // Email
          TextFormField(
            controller: controller.emailController,
            validator: controller.validateEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(height: WSizes.spaceBtwInputFields),

          // Phone Number
          TextFormField(
            controller: controller.phoneController,
            validator: controller.validatePhone,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Số điện thoại',
              prefixIcon: Icon(Iconsax.call),
              hintText: '0987654321 hoặc +84987654321',
            ),
          ),
          const SizedBox(height: WSizes.spaceBtwInputFields),

          // Address
          TextFormField(
            controller: controller.addressController,
            validator: controller.validateAddress,
            maxLines: 1,
            decoration: const InputDecoration(
              labelText: 'Địa chỉ',
              prefixIcon: Icon(Iconsax.location),
              hintText: 'Nhập địa chỉ của bạn',
            ),
          ),
          const SizedBox(height: WSizes.spaceBtwInputFields),

          // Date of Birth
          TextFormField(
                controller: controller.dateOfBirthController,
                validator: controller.validateDateOfBirth,
                readOnly: true,
                onTap: () => controller.selectDateOfBirth(context),
                decoration: const InputDecoration(
                  labelText: 'Ngày sinh',
                  prefixIcon: Icon(Iconsax.calendar),
                  suffixIcon: Icon(Iconsax.arrow_down_1),
                  hintText: 'Chọn ngày sinh',
                ),
              ),
          const SizedBox(height: WSizes.spaceBtwInputFields),

          // Password
          Obx(() => TextFormField(
                controller: controller.passwordController,
                validator: controller.validatePassword,
                obscureText: controller.isPasswordHidden.value,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: controller.togglePasswordVisibility,
                    icon: Icon(controller.isPasswordHidden.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye),
                  ),
                ),
              )),
          const SizedBox(height: WSizes.spaceBtwInputFields),

          // Confirm Password
          Obx(() => TextFormField(
                controller: controller.confirmPasswordController,
                validator: controller.validateConfirmPassword,
                obscureText: controller.isConfirmPasswordHidden.value,
                decoration: InputDecoration(
                  labelText: 'Xác nhận mật khẩu',
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: controller.toggleConfirmPasswordVisibility,
                    icon: Icon(controller.isConfirmPasswordHidden.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye),
                  ),
                ),
              )),
          const SizedBox(height: WSizes.spaceBtwSections),

          // Terms and Conditions
          Obx(() => Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: controller.termsAccepted.value,
                      onChanged: controller.toggleTermsAcceptance,
                    ),
                  ),
                  const SizedBox(width: WSizes.spaceBtwItems),
                  Expanded(
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: 'Tôi đồng ý với ',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextSpan(
                          text: 'Chính sách bảo mật',
                          style: Theme.of(context).textTheme.bodySmall!.apply(
                                color: dark ? WColors.white : WColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                        TextSpan(
                          text: ' và ',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextSpan(
                          text: 'Điều khoản sử dụng',
                          style: Theme.of(context).textTheme.bodySmall!.apply(
                                color: dark ? WColors.white : WColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ]),
                    ),
                  ),
                ],
              )),
          const SizedBox(height: WSizes.spaceBtwSections),

          // Sign up button
          Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      controller.isLoading.value ? null : controller.signup,
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Tạo tài khoản'),
                ),
              )),
        ],
      ),
    );
  }
}
