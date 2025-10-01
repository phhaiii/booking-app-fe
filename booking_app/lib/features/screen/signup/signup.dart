import 'package:booking_app/common/widgets.login_signup/form_divider.dart';
import 'package:booking_app/common/widgets.login_signup/social_button.dart';
import 'package:booking_app/features/screen/signup/signup_form.dart';
import 'package:booking_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:get/get_utils/src/extensions/export.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(WSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Title
              Text(WTexts.signupTitle,
                  style: Theme.of(context).textTheme.headlineMedium),

              //Form
              SignupForm(),
              const SizedBox(height: WSizes.spaceBtwItems),
              //Divider
              WFormDivider(dividerText: WTexts.orSignUpWith.capitalize!),
              const SizedBox(height: WSizes.spaceBtwItems),

              //social button
              const WSocialButton(),
              const SizedBox(height: WSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}

