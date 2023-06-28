import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/views/pages/post/post_page.dart';
import 'package:stacker_news/views/pages/profile/profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    final currentBuildNumber = packageInfo.buildNumber;

    return '$currentVersion+$currentBuildNumber';
  }

  static launchURL(String url) async {
    const snUrl = 'https://stacker.news/';

    if (url.contains('${snUrl}items/')) {
      final id = url.split('/').last;
      if (int.tryParse(id) == null) {
        throw 'Could not launch $url because id is not an integer';
      }

      final context = navigatorKey.currentContext;
      if (context == null) {
        throw 'Could not launch $url because context is null';
      }

      Navigator.of(context).pushNamed(
        PostPage.id,
        arguments: Post(id: id),
      );

      return;
    }

    if (url.contains(snUrl) && url.contains('?isUser=true')) {
      final userName = url.split('/').last.split('?').first;

      final context = navigatorKey.currentContext;
      if (context == null) {
        throw 'Could not launch $url because context is null';
      }

      Navigator.of(context).pushNamed(
        ProfilePage.id,
        arguments: userName,
      );

      return;
    }

    final uri = Uri.tryParse(url);

    if (uri == null) {
      throw 'Could not launch $url';
    } else if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
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
}
