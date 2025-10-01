import 'package:booking_app/features/controller/onboarding_controller.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:booking_app/utils/device/device_utility.dart';
import 'package:booking_app/utils/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:booking_app/utils/constants/colors.dart';



class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = WHelpersFunctions.isDarkMode(context); 
    return Positioned(
      right: WSizes.defaultSpace,
      bottom: WDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: () => OnboardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(shape: const CircleBorder(),backgroundColor: dark ? WColors.dark : WColors.light),
        child: const Icon(Iconsax.arrow_right_3),
        ),
      );
  }
}


