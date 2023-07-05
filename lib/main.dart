import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stacker_news/data/sn_api.dart';
import 'package:stacker_news/sn_router.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/home_page.dart';

import 'colors.dart';

final locator = GetIt.instance;

void main() {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
  }

  locator.registerLazySingleton(Api.new);

  runApp(const StackerNewsApp());
}

class StackerNewsApp extends StatefulWidget {
  const StackerNewsApp({super.key});

  @override
  State<StackerNewsApp> createState() => _StackerNewsAppState();
}

class _StackerNewsAppState extends State<StackerNewsApp> {
  @override
  void initState() {
    super.initState();

    if (mounted) {
      Utils.checkForUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Utils.navigatorKey,
      scaffoldMessengerKey: Utils.scaffoldMessengerKey,
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
