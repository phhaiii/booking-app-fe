import 'package:flutter/material.dart';

class WChipTheme {
  WChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    selectedColor: Colors.blue,
    disabledColor: Colors.grey,
    labelStyle: TextStyle(color: Colors.black),
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    selectedColor: Colors.blue,
    disabledColor: Colors.grey,
    labelStyle: TextStyle(color: Colors.white),
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
  );
}
