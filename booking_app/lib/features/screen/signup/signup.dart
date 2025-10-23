import 'package:booking_app/common/widgets.login_signup/form_divider.dart';
import 'package:booking_app/common/widgets.login_signup/social_button.dart';
import 'package:booking_app/features/controller/signup_controller.dart';
import 'package:booking_app/features/screen/signup/signup_form.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/utils/constants/text_strings.dart';
import 'package:booking_app/utils/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {

    Get.put(SignupController());

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(WSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                WTexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: WSizes.spaceBtwSections),

              // Form
              const SignupForm(),
              const SizedBox(height: WSizes.spaceBtwSections),

              // Divider
              WFormDivider(dividerText: WTexts.orSignUpWith.capitalize!),
              const SizedBox(height: WSizes.spaceBtwSections),

              // Social Buttons
              const WSocialButton(),
            ],
          ),
        ),
      ),
    );
  }
}
