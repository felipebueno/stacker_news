import 'package:flutter/material.dart';
import 'package:stacker_news/pages/home_page.dart';
import 'package:stacker_news/sn_router.dart';
import 'package:stacker_news/utils.dart';

import 'colors.dart';

void main() {
  Utils.checkForUpdate();
  runApp(const StackerNewsApp());
}

class StackerNewsApp extends StatelessWidget {
  const StackerNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stacker News',
      themeMode: ThemeMode
          .dark, // TODO: Implement theme switcher and change this to ThemeMode.system
      theme: ThemeData(
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
      ),
      darkTheme: ThemeData(
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
      ),
      initialRoute: HomePage.id,
      routes: SNRouter.routes,
      home: const HomePage(),
    );
  }
}
