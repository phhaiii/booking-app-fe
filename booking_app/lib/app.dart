import 'package:booking_app/features/controller/signup_controller.dart';
import 'package:booking_app/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'features/screen/onboarding/onboarding.dart';
import 'package:get/get.dart';
import 'package:booking_app/features/controller/login_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    Get.put(SignupController());
    return GetMaterialApp(
      title: 'Wedding App',
      themeMode: ThemeMode.system,
      theme: WAppTheme.lightTheme,
      darkTheme: WAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}
