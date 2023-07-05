import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:stacker_news/data/sn_api.dart';
import 'package:stacker_news/sn_router.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/home_page.dart';
import 'package:uni_links/uni_links.dart';

import 'colors.dart';

final locator = GetIt.instance;
bool _initialUriIsHandled = false;

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
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      _handleIncomingLinks();
      _handleInitialUri();
      Utils.checkForUpdate();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();

    super.dispose();
  }

  bool _isLoginLink(String link) =>
      link.contains('https://stacker.news/api/auth/callback/email');

  Future<void> _login(String link) async {
    try {
      // Utils.showBusyModal(
      //   context: context,
      //   message: 'Logging in...',
      // );

      final session = await locator<Api>().login(link);

      if (session != null) {
        final ctx = Utils.navigatorKey.currentContext;

        if (ctx == null) {
          Utils.showError('Error going to home page. Context is null');

          return;
        }

        if (ctx.mounted) {
          Navigator.pushReplacementNamed(ctx, HomePage.id);
        } else {
          Utils.showError('Error going to home page. Context is not mounted');
        }
      }
    } catch (e, st) {
      Utils.showException('Error logging in $e', st);
    } finally {
      // Utils.hideBusyModal(context);
    }
  }

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in the foreground or in the background.
      _sub = linkStream.listen(
        (String? link) async {
          if (link == null) return;
          if (!_isLoginLink(link)) return;
          if (!mounted) return;

          _login(link);
        },
        onError: (Object err) {
          if (!mounted) return;

          Utils.showError('Unilinks Error: $err');
        },
      );
    }
  }

  Future<void> _handleInitialUri() async {
    if (_initialUriIsHandled) return;

    _initialUriIsHandled = true;
    try {
      final link = await getInitialLink();
      if (link == null) return;
      if (!_isLoginLink(link)) return;
      if (!mounted) return;

      Utils.showInfo('got initial link: $link');

      if (!mounted) return;

      _login(link);
    } on PlatformException {
      // Platform messages may fail but we ignore the exception
      Utils.showError('falied to get initial uri');
    } on FormatException catch (_) {
      if (!mounted) return;
      Utils.showError('malformed initial uri');
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
