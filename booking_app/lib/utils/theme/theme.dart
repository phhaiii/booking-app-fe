import 'package:booking_app/utils/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/utils/theme/elevated_button_theme.dart';
import 'package:booking_app/utils/theme/app_bar_theme.dart';
import 'package:booking_app/utils/theme/chip.dart';
import 'package:booking_app/utils/theme/checkbox_theme.dart'; 
import 'package:booking_app/utils/theme/outlined_button_theme.dart';
import 'package:booking_app/utils/theme/text_field_theme.dart';
import 'package:booking_app/utils/constants/colors.dart';

class WAppTheme {
  WAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Playfair Display',
    brightness: Brightness.light,
    primaryColor: WColors.primary,
    scaffoldBackgroundColor: Colors.white,
    textTheme: WTextTheme.lightTextTheme,
    elevatedButtonTheme: WElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: WAppBarTheme.lightAppBarTheme,
    chipTheme: WChipTheme.lightChipTheme,
    checkboxTheme: WCheckboxTheme.lightCheckboxTheme,
    outlinedButtonTheme: WOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: WTextFormFieldTheme.lightInputDecorationTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Playfair Display',
    brightness: Brightness.dark,
    primaryColor: WColors.primary,
    scaffoldBackgroundColor: Colors.black,
    textTheme: WTextTheme.darkTextTheme,
    elevatedButtonTheme: WElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: WAppBarTheme.darkAppBarTheme,
    chipTheme: WChipTheme.darkChipTheme,
    checkboxTheme: WCheckboxTheme.darkCheckboxTheme,
    outlinedButtonTheme: WOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: WTextFormFieldTheme.darkInputDecorationTheme,
  );
}
