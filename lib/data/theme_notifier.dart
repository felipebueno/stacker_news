import 'package:flutter/material.dart';
import 'package:stacker_news/colors.dart';

import 'shared_prefs_manager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.black,
      surfaceTintColor: Colors.black,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: snYellow,
      brightness: Brightness.dark,
      background: Colors.black,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: snYellow,
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: snYellow,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: snYellow,
      ),
    ),
  );

  final lightTheme = ThemeData(
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: snYellow,
      brightness: Brightness.light,
      background: Colors.white,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: snYellow,
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: snYellow,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: snYellow,
        foregroundColor: Colors.black,
      ),
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
    SharedPrefsManager.create('theme-mode', value);

    notifyListeners();
  }
}
