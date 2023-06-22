import 'package:flutter/material.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/profile/profile_page.dart';
import 'package:stacker_news/views/widgets/sn_logo.dart';

class StackButton extends StatelessWidget {
  const StackButton(
    this.user, {
    this.navigateToProfile = false,
    super.key,
  });

  final String user;
  final bool navigateToProfile;

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
        if (navigateToProfile) {
          Navigator.pushNamed(
            context,
            ProfilePage.id,
            arguments: user,
          );

          return;
        }

        Utils.launchURL('lightning:$user@stacker.news');
      },
    );
  }
}
