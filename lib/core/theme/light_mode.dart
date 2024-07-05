import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Color(0xffEBF4F6),
    primary: Color(0xff088395),
    secondary: Color(0xff37B7C3),
    tertiary: Color(0xff071952),
    inversePrimary: Colors.cyan,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Colors.black,
      fontSize: 17,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w300,
    )
  )
);

