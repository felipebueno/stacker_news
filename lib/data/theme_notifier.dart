import 'package:flutter/material.dart';
import 'package:stacker_news/colors.dart';

import 'shared_prefs_manager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: SNColors.primary,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      foregroundColor: SNColors.primary,
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: SNColors.primary,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: SNColors.primary,
      unselectedItemColor: SNColors.light,
      showUnselectedLabels: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: SNColors.primary,
      ),
    ),
  );

  final lightTheme = ThemeData.light().copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: SNColors.primary,
    ),
  );

  ThemeMode? _themeData;
  ThemeMode? get themeMode => _themeData;
  String get themeModeString {
    switch (_themeData) {
      case ThemeMode.light:
        return 'Light';

      case ThemeMode.dark:
        return 'Dark';

      case ThemeMode.system:
        return 'System';

      default:
        return 'Dark';
    }
  }

  ThemeNotifier() {
    SharedPrefsManager.read('theme-mode').then(
      (value) {
        setThemeMode(value);

        notifyListeners();
      },
    );
  }

  void setThemeMode(String? value) async {
    String? themeMode = value ?? 'Dark';

    switch (themeMode) {
      case 'Light':
        _themeData = ThemeMode.light;
        break;

      case 'Dark':
        _themeData = ThemeMode.dark;
        break;

      case 'System':
        _themeData = ThemeMode.system;
        break;

      default:
        _themeData = ThemeMode.dark;
    }
    SharedPrefsManager.create('theme-mode', themeMode);

    notifyListeners();
  }
}
