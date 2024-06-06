import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:stacker_news/data/api.dart';
import 'package:stacker_news/data/auth_service.dart';
import 'package:stacker_news/sn_router.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/home_page.dart';
import 'package:uni_links/uni_links.dart';

import 'data/theme_notifier.dart';

final locator = GetIt.instance;
bool _initialUriIsHandled = false;

void main() {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
  }

  locator.registerLazySingleton(Api.new);

  runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(),
    child: const StackerNewsApp(),
  ));
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

    if (!kIsWeb && mounted && Platform.isAndroid) {
      _handleIncomingLinks();
      _handleInitialUri();
      Utils.checkForUpdate();
    } else if (mounted && kIsWeb) {
      // TODO: Utils.checkForWebUpdate();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();

    super.dispose();
  }

  bool _isLoginLink(String link) =>
      link.contains('https://stacker.news/api/auth/callback/email');

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in the foreground or in the background.
      _sub = linkStream.listen(
        (String? link) async {
          if (link == null) return;
          if (!_isLoginLink(link)) return;
          if (!mounted) return;

          login(link);
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

      login(link);
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
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) {
        return MaterialApp(
          navigatorKey: Utils.navigatorKey,
          scaffoldMessengerKey: Utils.scaffoldMessengerKey,
          title: 'Stacker News',
          themeMode: theme.themeMode,
          theme: theme.lightTheme,
          darkTheme: theme.darkTheme,
          initialRoute: HomePage.id,
          routes: SNRouter.routes,
          home: const HomePage(),
        );
      },
    );
  }
}
