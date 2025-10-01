import 'package:booking_app/features/screen/dashboard/dashboard.dart';
import 'package:booking_app/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'features/screen/onboarding/onboarding.dart';
import 'package:get/get.dart';
import 'package:booking_app/service/authentication.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return GetMaterialApp(
      title: 'Wedding App',
      themeMode: ThemeMode.system,
      theme: WAppTheme.lightTheme,
      darkTheme: WAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen(),
    );
  }
}
