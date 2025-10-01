import 'package:flutter/material.dart';


class WColors {
  WColors._();

  static const Color primary =Color.fromARGB(255, 133, 153, 74);
  static const Color secondaryColor = Color.fromARGB(255, 187, 135, 51);
  static const Color accentColor = Color(0xFFFFFFFF);

  // Gardient colors

  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, 0.707),
    colors: [Color(0xFF42A5F5), Color(0xFF478DE0)],
  );
  
  // Text colors
  static const Color textPrimaryColor = Color(0xFF000000);
  static const Color textSecondaryColor = Color(0xFF888888);
  static const Color textWhite = Colors.white;

  // Background colors
  static const Color light = Color(0xFFF4F6F8);
  static const Color dark = Color(0xFF121212);
  static const Color primaryBackground = Color(0xFFE3F2FD);
  
  // Background container colors
  static const Color containerLight = Color(0xFFF6F6F6);
  static Color containerDark = WColors.white.withOpacity(0.1);

  // Button colors
  static const Color buttonPrimary = Color.fromARGB(255, 203, 201, 73);
  static const Color buttonSecondary = Color(0xFF888888);
  static const Color buttonDisabled = Color(0xFFCCCCCC);

  // Border colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF333333);

  // Error and success colors
  static const Color errorColor = Color(0xFFFF5252);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color infoColor = Color(0xFF2196F3);

  // Natural Shades
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF616161);


}