import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/colors.dart';

class WChipTheme {
  WChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    selectedColor: WColors.primary,
    disabledColor: Colors.grey,
    labelStyle: TextStyle(color: Colors.black),
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    selectedColor: WColors.primary,
    disabledColor: Colors.grey,
    labelStyle: TextStyle(color: Colors.white),
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
  );
}
