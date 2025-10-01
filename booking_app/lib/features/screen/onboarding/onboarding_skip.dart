import 'package:booking_app/features/controller/onboarding_controller.dart';
import 'package:booking_app/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/sizes.dart';


class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: WDeviceUtils.getAppBarHeight(),
        right: WSizes.defaultSpace,
        child:
            TextButton(onPressed: () => OnboardingController.instance.skipPage(), child: const Text('Skip')));
  }
}
