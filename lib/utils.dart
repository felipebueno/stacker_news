import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/data/models/session.dart';
import 'package:stacker_news/data/shared_prefs_manager.dart';
import 'package:stacker_news/data/sn_api_client.dart';
import 'package:stacker_news/views/pages/pdf_reader/pdf_reader_page.dart';
import 'package:stacker_news/views/pages/post/post_page.dart';
import 'package:stacker_news/views/pages/profile/profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    final currentBuildNumber = packageInfo.buildNumber;

    return '$currentVersion+$currentBuildNumber';
  }

  static launchURL(String url) async {
    final context = navigatorKey.currentContext;

    if (context == null) {
      showError('Could not launch $url because context is null');

      return;
    }

    try {
      if (url.endsWith('.pdf')) {
        Navigator.of(context).pushNamed(
          PdfReaderPage.id,
          arguments: url,
        );

        return;
      }
    } catch (_) {}

    const snUrl = '$baseUrl/';

    if (url.contains('${snUrl}items/')) {
      final id = url.split('/').last;
      if (int.tryParse(id) == null) {
        showError('Could not launch $url because id is not an integer');

        return;
      }

      Navigator.of(context).pushNamed(
        PostPage.id,
        arguments: Post(id: id),
      );

      return;
    }

    if (url.contains(snUrl) && url.contains('?isUser=true')) {
      final userName = url.split('/').last.split('?').first;

      Navigator.of(context).pushNamed(
        ProfilePage.id,
        arguments: userName,
      );

      return;
    }

    final uri = Uri.tryParse(url);

    if (uri == null) {
      showError('Could not launch $url');

      return;
    } else if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showError('Could not launch $url');

      return;
    }
  }

  static void hideBusyModal([BuildContext? context]) {
    final ctx = context ?? navigatorKey.currentContext;

    if (ctx == null) {
      debugPrint('Could not hide busy modal because context is null');

      return;
    }

    // TODO: We should check if the modal is open before popping it
    if (Navigator.of(ctx).canPop()) {
      Navigator.of(ctx).pop();
    }
  }

  static void showBusyModal({String? message, BuildContext? context}) {
    final ctx = context ?? navigatorKey.currentContext;

    if (ctx == null) {
      debugPrint('Could not show busy modal because context is null');

      return;
    }

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (context) {
        return Material(
          color: Colors.black12.withValues(alpha: .7),
          child: PopScope(
            canPop: false,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    if (message != null) ...[
                      const SizedBox(height: 20),
                      Text(message),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void showInfo(String message) {
    debugPrint(message);
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showWarning(String message) {
    debugPrint(message);
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
      ),
    );
  }

  static void showError(String message) {
    debugPrint(message);
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

    try {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (_) {}
  }

  static void showException(String message, StackTrace st) {
    debugPrint(message);
    debugPrintStack(
      label: message,
      stackTrace: st,
    );
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

    try {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (_) {}
  }

  static Future<void> checkForUpdate() async {
    if (kIsWeb || kDebugMode || !Platform.isAndroid) {
      return;
    }

    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable &&
          info.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e, st) {
      debugPrintStack(
        label: e.toString(),
        stackTrace: st,
      );
      // TODO: Do something with this error
    }
  }

  static Future<Session?> getSession() async {
    final sessionData = await SharedPrefsManager.get('session');

    if (sessionData == null || sessionData == 'null' || sessionData == '{}') {
      return null;
    }

    return Session.fromJson(jsonDecode(sessionData));
  }
}
