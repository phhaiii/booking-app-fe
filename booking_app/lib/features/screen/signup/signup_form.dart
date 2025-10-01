import 'package:booking_app/utils/constants/colors.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/utils/constants/text_strings.dart';
import 'package:booking_app/utils/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key,});



  @override
  Widget build(BuildContext context) {
    final dark = WHelpersFunctions.isDarkMode(context);

    return Form(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: InputDecoration(
                      labelText: WTexts.firstName,
                      prefixIcon: Icon(Iconsax.user)),
                ),
              ),
              const SizedBox(width: WSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: InputDecoration(
                      labelText: WTexts.lastName,
                      prefixIcon: Icon(Iconsax.user)),
                ),
              ),
            ],
          ),
          const SizedBox(height: WSizes.spaceBtwInputFields),
          //username
          TextFormField(
            expands: false,
            decoration: const InputDecoration(
                labelText: WTexts.username,
                prefixIcon: Icon(Iconsax.user_edit)),
          ),
          const SizedBox(height: WSizes.spaceBtwInputFields),
          //email
          TextFormField(
            expands: false,
            decoration: const InputDecoration(
                labelText: WTexts.email,
                prefixIcon: Icon(Iconsax.user)),
          ),
          const SizedBox(height: WSizes.spaceBtwInputFields),
          //phone number
          TextFormField(
            expands: false,
            decoration: const InputDecoration(
                labelText: WTexts.phoneNo,
                prefixIcon: Icon(Iconsax.call)),
          ),
          const SizedBox(height: WSizes.spaceBtwInputFields),
          //password
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
                labelText: WTexts.password,
                prefixIcon: Icon(Iconsax.check),
                suffixIcon: Icon(Iconsax.eye_slash)),
          ),
          const SizedBox(height: WSizes.spaceBtwSections),
          //Terms and conditions
          Row(
            children: [
              SizedBox(
                  width: 24,
                  height: 24,
                  child:
                      Checkbox(value: true, onChanged: (value) {})),
              const SizedBox(width: WSizes.spaceBtwItems),
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: '${WTexts.iAgreeTo} ',
                      style: Theme.of(context).textTheme.bodySmall),
                  TextSpan(
                      text: WTexts.privacyPolicy,
                      style: Theme.of(context).textTheme.bodySmall!.apply(color: dark? WColors.white: WColors.primary,
                            decoration: TextDecoration.underline,
                          )),
                  TextSpan(
                      text: ' ${WTexts.and} ',
                      style: Theme.of(context).textTheme.bodySmall),
                  TextSpan(
                      text: WTexts.termsAndConditions,
                      style: Theme.of(context).textTheme.bodySmall!.apply(color: dark ? WColors.white : WColors.primary,
                            decoration: TextDecoration.underline,
                          )),
                ]),
              ),
            ],
          ),
          const SizedBox(height: WSizes.spaceBtwSections),
    
          //Sign up button
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {},
                  child: Text(WTexts.createAccount))),
        ],
      ),
    );
  }
}
