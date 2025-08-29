import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:stacker_news/data/sn_api_client.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/about/about_page.dart';
import 'package:stacker_news/views/pages/auth/check_email_page.dart';
import 'package:stacker_news/views/pages/auth/sign_in_failed_page.dart';
import 'package:stacker_news/views/pages/auth/sign_in_page.dart';
import 'package:stacker_news/views/pages/home_page.dart';
import 'package:stacker_news/views/pages/new_post/new_bounty_page.dart';
import 'package:stacker_news/views/pages/new_post/new_discussion_page.dart';
import 'package:stacker_news/views/pages/new_post/new_job_page.dart';
import 'package:stacker_news/views/pages/new_post/new_link_page.dart';
import 'package:stacker_news/views/pages/new_post/new_poll_page.dart';
import 'package:stacker_news/views/pages/new_post/new_post_page.dart';
import 'package:stacker_news/views/pages/notifications/notifications_page.dart';
import 'package:stacker_news/views/pages/pdf_reader/pdf_reader_page.dart';
import 'package:stacker_news/views/pages/post/post_page.dart';
import 'package:stacker_news/views/pages/profile/profile_page.dart';
import 'package:stacker_news/views/pages/settings/settings_page.dart';

import 'data/theme_notifier.dart';

final locator = GetIt.instance;
bool _initialUriAlreadyHandled = false;

void main() {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
  }

  locator.registerLazySingleton(SNApiClient.new);

  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: const StackerNewsApp(),
    ),
  );
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

  // bool _isLoginLink(String link) => link.contains('$baseUrl/api/auth/callback/email');

  void _handleIncomingLinks() {
    // if (!kIsWeb) {
    //   final appLinks = AppLinks(); // AppLinks is singleton
    //   // It will handle app links while the app is already started - be it in the foreground or in the background.
    //   _sub = appLinks.uriLinkStream.listen(
    //     (uri) async {
    //       final url = uri.toString();
    //       if (!_isLoginLink(url)) return;
    //       if (!mounted) return;

    //       login(url);
    //     },
    //     onError: (Object err) {
    //       if (!mounted) return;

    //       Utils.showError('Unilinks Error: $err');
    //     },
    //   );
    // }
  }

  Future<void> _handleInitialUri() async {
    if (_initialUriAlreadyHandled) return;

    _initialUriAlreadyHandled = true;
    // try {
    //   final uri = await AppLinks().getInitialLink();
    //   if (uri == null) return;
    //   final url = uri.toString();
    //   if (!_isLoginLink(url)) return;
    //   if (!mounted) return;

    //   login(url);
    // } on PlatformException {
    //   // Platform messages may fail but we ignore the exception
    //   Utils.showError('falied to get initial uri');
    // } on FormatException catch (_) {
    //   if (!mounted) return;
    //   Utils.showError('malformed initial uri');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ThemeNotifier>(
        builder: (context, theme, _) {
          return MaterialApp(
            navigatorKey: Utils.navigatorKey,
            scaffoldMessengerKey: Utils.scaffoldMessengerKey,
            title: 'Stacker News',
            themeMode: theme.themeMode,
            theme: theme.lightTheme,
            darkTheme: theme.darkTheme,
            initialRoute: HomePage.id,
            routes: {
              HomePage.id: (context) => const HomePage(),
              PostPage.id: (context) => const PostPage(),
              SettingsPage.id: (context) => const SettingsPage(),
              ProfilePage.id: (context) => const ProfilePage(),
              AboutPage.id: (context) => const AboutPage(),
              SignInPage.id: (context) => const SignInPage(),
              CheckEmailPage.id: (context) => const CheckEmailPage(),
              LoginFailedPage.id: (context) => const LoginFailedPage(),
              NotificationsPage.id: (context) => const NotificationsPage(),
              NewPostPage.id: (context) => const NewPostPage(),
              NewLinkPage.id: (context) => const NewLinkPage(),
              NewDiscussionPage.id: (context) => const NewDiscussionPage(),
              NewPollPage.id: (context) => const NewPollPage(),
              NewBountyPage.id: (context) => const NewBountyPage(),
              NewJobPage.id: (context) => const NewJobPage(),
              PdfReaderPage.id: (context) => const PdfReaderPage(),
            },
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
