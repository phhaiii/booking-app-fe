import 'package:booking_app/features/screen/signup/signup.dart';
import 'package:booking_app/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/text_strings.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class WLoginForm extends StatelessWidget {
  const WLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: WSizes.spaceBtwSections),
        child: Column(
          children: [
            //Email
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                label: Text(WTexts.email),
                hintText: WTexts.hintEmail,
              ),
            ),
            const SizedBox(height: WSizes.spaceBtwInputFields),
            //Password
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                label: Text(WTexts.password),
                hintText: WTexts.hintPassword,
                suffixIcon: Icon(Iconsax.eye_slash),
              ),
            ),
            const SizedBox(height: WSizes.spaceBtwInputFields / 2),

            //Remember me and forgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///remember me
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text(WTexts.rememberMe),
                  ],
                ),

                ///Forgot password
                TextButton(
                    onPressed: () {}, child: Text(WTexts.forgetPassword)),
              ],
            ),
            const SizedBox(height: WSizes.spaceBtwSections),

            ///Sign in button
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const NavigationMenu()),
                  child: const Text(WTexts.signIn),
                )),
            const SizedBox(height: WSizes.spaceBtwItems),

            ///Create Account
            SizedBox(
                width: double.infinity,
                child: OutlinedButton(onPressed: () => Get.to(()=> const SignupScreen()),child: const Text(WTexts.createAccount),
                )),
          ],
        ),
      ),
    );
  }
}