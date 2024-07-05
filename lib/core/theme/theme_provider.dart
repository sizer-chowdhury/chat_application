import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dark_mode.dart';
import 'light_mode.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
      (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light);

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

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
