import 'package:booking_app/features/controller/onboarding_controller.dart';
import 'package:booking_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/utils/device/device_utility.dart';
import 'package:booking_app/utils/helpers/helpers.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:booking_app/utils/constants/colors.dart';


class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance; 
    final dark = WHelpersFunctions.isDarkMode(context);
    return Positioned(
      bottom: WDeviceUtils.getBottomNavigationBarHeight() + 25,
      left: WSizes.defaultSpace,
      child: SmoothPageIndicator(
        count: 3,
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        effect: ExpandingDotsEffect(
            activeDotColor: dark ? WColors.dark : WColors.light, dotHeight: 6),
      ),
    );
  }
}