import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dark_mode.dart';
import 'light_mode.dart';

// Import your lightMode and darkMode themes

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
      (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light); // Set initial theme (light)

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  // Access lightMode and darkMode here if needed
  ThemeData getThemeData(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return lightMode;
      case ThemeMode.dark:
        return darkMode;
      default:
        throw Exception('Unsupported theme mode');
    }
  }
}

enum ThemeMode { light, dark }
