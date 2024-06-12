import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/session.dart';
import 'package:stacker_news/data/sn_api_client.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/auth/sign_in_page.dart';
import 'package:stacker_news/views/pages/notifications/notifications_page.dart';
import 'package:stacker_news/views/pages/profile/profile_page.dart';

class MaybeNotificationsButton extends StatefulWidget {
  const MaybeNotificationsButton({super.key});

  @override
  State<MaybeNotificationsButton> createState() =>
      _MaybeNotificationsButtonState();
}

class _MaybeNotificationsButtonState extends State<MaybeNotificationsButton> {
  bool _hasNewNotes = false;
  Timer? _timer;

  void _startFetchingNewNotes() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      final ret = await locator<SNApiClient>().hasNewNotes();

      if (mounted) {
        setState(() {
          _hasNewNotes = ret;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Utils.getSession(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data is Session) {
          _startFetchingNewNotes();

          final session = snapshot.data as Session;

          return Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    NotificationsPage.id,
                    arguments: session.user?.name,
                  );
                },
                icon: Icon(
                  _hasNewNotes
                      ? Icons.notifications_active
                      : Icons.notifications,
                  color: _hasNewNotes ? Colors.green : null,
                ),
              ),
              TextButton(
                child: Text('@${session.user?.name}'),
                onPressed: () async {
                  Navigator.pushNamed(
                    context,
                    ProfilePage.id,
                    arguments: session.user?.name,
                  );
                },
              ),
            ],
          );
        }

        return IconButton(
          icon: const Icon(Icons.login),
          onPressed: () async {
            Navigator.pushNamed(context, SignInPage.id);
          },
        );
      },
    );
  }
}
