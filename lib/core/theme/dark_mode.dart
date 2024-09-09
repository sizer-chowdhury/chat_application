import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Color(0xff222831),
    primary: Color(0xff76ABAE),
    secondary: Color(0xff31363F),
    tertiary: Color(0xffEEEEEE),
    inversePrimary: Colors.cyan,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Colors.white,
      fontSize: 17,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.w300,
    ),
    titleSmall: TextStyle(
      color: Color(0xff76ABAE),
      fontSize: 14,
    ),
  ),
);
