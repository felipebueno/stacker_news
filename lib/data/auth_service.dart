import 'package:flutter/material.dart';
import 'package:stacker_news/data/sn_api_client.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/home_page.dart';

Future<void> login(String link) async {
  try {
    // TODO: Show busy indicator while logging in
    // Utils.showBusyModal(
    //   context: context,
    //   message: 'Logging in...',
    // );

    final session = await locator<SNApiClient>().login(link);

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
