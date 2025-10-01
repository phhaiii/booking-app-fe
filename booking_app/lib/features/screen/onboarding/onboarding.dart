import 'package:booking_app/features/controller/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/image_strings.dart';
import 'package:booking_app/utils/constants/text_strings.dart';
import 'package:booking_app/features/screen/onboarding/onboarding_page.dart';
import 'package:booking_app/features/screen/onboarding/onboarding_skip.dart';
import 'package:booking_app/features/screen/onboarding/onboarding_dot_navigation.dart';
import 'package:booking_app/features/screen/onboarding/onboarding_next_button.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    
    return Scaffold(
      body: Stack(
        children: [
          //Horizontal PageView
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: WImages.onBoardingImage1,
                title: WTexts.onboardingTitle1,
                subtitle: WTexts.onboardingSubtitle1,
              ),

              OnBoardingPage(
                image: WImages.onBoardingImage2,
                title: WTexts.onboardingTitle2,
                subtitle: WTexts.onboardingSubtitle2,
              ),

              OnBoardingPage(
                image: WImages.onBoardingImage3,
                title: WTexts.onboardingTitle3,
                subtitle: WTexts.onboardingSubtitle3,
              ),
            ],
          ),
              //Skip button
              const OnBoardingSkip(),
              //Dot navigation smooth_page_indicator
              const OnBoardingDotNavigation(),
              //Circular arrow button
              const OnBoardingNextButton(),
        ],
      ),
    );
  }
}
