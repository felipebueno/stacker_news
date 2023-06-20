import 'package:flutter/material.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/widgets/sn_logo.dart';

class StackButton extends StatelessWidget {
  const StackButton(
    this.user, {
    super.key,
  });

  final String user;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const SNLogo(
        size: 16,
        color: Colors.black,
        heroTag: 'zap',
        hideShadow: true,
      ),
      label: Text('$user@stacker.news'),
      onPressed: () {
        Utils.launchURL('https://stacker.news/$user'); // TODO: Launch LNURL
      },
    );
  }
}
