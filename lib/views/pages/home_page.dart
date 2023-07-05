import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/post_type.dart';
import 'package:stacker_news/data/models/session.dart';
import 'package:stacker_news/data/sn_api.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/auth/sign_in_page.dart';
import 'package:stacker_news/views/pages/notifications/notifications_page.dart';
import 'package:stacker_news/views/pages/profile/profile_page.dart';
import 'package:stacker_news/views/widgets/base_tab.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';
import 'package:stacker_news/views/widgets/sn_logo.dart';

class HomePage extends StatelessWidget {
  static const String id = 'home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = PostType.values
        .where((p) => p != PostType.notifications)
        .map((t) => Tab(
              icon: Icon(t.icon),
              child: SizedBox(
                width: 64,
                child: Center(child: Text(t.title)),
              ),
            ))
        .toList();

    final tabViews = PostType.values
        .where((p) => p != PostType.notifications)
        .map((t) => BaseTab(postType: t))
        .toList();

    return DefaultTabController(
      length: tabs.length,
      child: GenericPageScaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const SNLogo(),
          bottom: TabBar(
            isScrollable: true,
            tabs: tabs,
          ),
          actions: const [
            MaybeNotificationsButton(),
          ],
        ),
        mainBody: TabBarView(children: tabViews),
        fab: const MaybeNewPostFab(),
      ),
    );
  }
}

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
      final ret = await locator<Api>().hasNewNotes();

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

class MaybeNewPostFab extends StatefulWidget {
  const MaybeNewPostFab({super.key});

  @override
  State<MaybeNewPostFab> createState() => _MaybeNewPostFabState();
}

class _MaybeNewPostFabState extends State<MaybeNewPostFab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Utils.getSession(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data is Session) {
          final session = snapshot.data as Session;

          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamed(
                context,
                ProfilePage.id,
                arguments: session.user?.name,
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Post'),
          );
        }

        return Container();
      },
    );
  }
}
