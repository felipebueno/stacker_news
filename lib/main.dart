import 'package:flutter/material.dart';
import 'package:stacker_news/pages/home.dart';
import 'package:stacker_news/sn_router.dart';

import 'colors.dart';

void main() {
  runApp(const StackerNewsApp());
}

class StackerNewsApp extends StatelessWidget {
  const StackerNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stacker News',
      theme: ThemeData(
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
      initialRoute: Home.id,
      routes: HNRouter.routes,
      home: const Home(),
    );
  }
}
