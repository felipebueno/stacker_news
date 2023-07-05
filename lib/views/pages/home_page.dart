import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacker_news/data/models/post_type.dart';
import 'package:stacker_news/views/pages/auth/sign_in_page.dart';
import 'package:stacker_news/views/widgets/base_tab.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';
import 'package:stacker_news/views/widgets/sn_logo.dart';

class HomePage extends StatelessWidget {
  static const String id = 'home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = PostType.values
        .map((t) => Tab(
              icon: Icon(t.icon),
              child: SizedBox(
                width: 64,
                child: Center(child: Text(t.title)),
              ),
            ))
        .toList();

    final tabViews = PostType.values.map((t) => BaseTab(postType: t)).toList();

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
  Future<bool> _getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionData = prefs.getString('session');
    return sessionData != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getSession(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('session');

              setState(() {});
            },
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
