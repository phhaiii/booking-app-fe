import 'package:booking_app/common/styles/spacing_styles.dart';
import 'package:booking_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/features/screen/login/login_header.dart';
import 'package:booking_app/features/screen/login/login_form.dart';
import 'package:booking_app/features/controller/login_controller.dart';
import 'package:get/get.dart';
import 'package:booking_app/common/widgets.login_signup/form_divider.dart';
import 'package:booking_app/common/widgets.login_signup/social_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo AuthController
    Get.lazyPut(() => AuthController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: WSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              // Logo, Title, Subtitle
              const WLoginHeader(),

              // Form
              const WLoginForm(),

              // Divider
              WFormDivider(dividerText: WTexts.orSignInWith.capitalize!),
              const SizedBox(height: WSizes.spaceBtwItems),

              // Footer - Social Buttons
              const WSocialButton()
            ],
          ),
        ),
      ),
    );
  }
}
