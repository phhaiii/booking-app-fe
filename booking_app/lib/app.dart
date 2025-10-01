import 'package:booking_app/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'features/screen/onboarding/onboarding.dart';
import 'package:get/get.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Wedding App',
      themeMode: ThemeMode.system, 
      theme: WAppTheme.lightTheme,
      darkTheme: WAppTheme.darkTheme,
      home: const OnboardingScreen(),
    );
  }
}