import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/post_type.dart';
import 'package:stacker_news/views/widgets/base_tab.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';
import 'package:stacker_news/views/widgets/maybe_new_post_button.dart';
import 'package:stacker_news/views/widgets/maybe_notifications_button.dart';
import 'package:stacker_news/views/widgets/sn_logo.dart';

class HomePage extends StatelessWidget {
  static const String id = 'home';

  const HomePage({super.key});
  List<Tab> get _tabs => PostType.values
      .where((p) => p != PostType.notifications)
      .map(
        (t) => Tab(
          icon: Icon(t.icon),
          child: SizedBox(
            width: 72,
            child: Center(
              child: Text(
                t.title,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      )
      .toList();

  List<BaseTab> get _tabViews => PostType.values
      .where(
        (p) => p != PostType.notifications,
      )
      .map(
        (t) => BaseTab(postType: t),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: GenericPageScaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const SNLogo(),
          actions: const [
            MaybeNotificationsButton(),
          ],
        ),
        mainBody: TabBarView(children: _tabViews),
        bottomNavigationBar: TabBar(
          isScrollable: true,
          tabs: _tabs,
        ),
        fab: const MaybeNewPostFab(),
      ),
    );
  }
}
