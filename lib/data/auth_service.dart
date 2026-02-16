import 'package:flutter/material.dart';
import 'package:stacker_news/data/sn_api_client.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/home_page.dart';

Future<void> login({
  required String email,
  required String magicCode,
}) async {
  try {
    // TODO:
    // Utils.showBusyModal(
    //   context: context,
    //   message: 'Logging in...',
    // );

    final session = await locator<SNApiClient>().loginWithMagicCode(
      email: email,
      magicCode: magicCode,
    );

    if (session != null) {
      final ctx = Utils.navigatorKey.currentContext;

      if (ctx == null) {
        Utils.showError('Error going home. Context is null');

        return;
      }

      if (ctx.mounted) {
        await Navigator.pushReplacementNamed(ctx, HomePage.id);
      } else {
        Utils.showError('Error going home. Context is not mounted');
      }
    }
  } catch (e, st) {
    Utils.showException('Error logging in $e', st);
  } finally {
    // Utils.hideBusyModal(context);
  }
}
