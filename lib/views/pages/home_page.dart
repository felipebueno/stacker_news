import 'package:flutter/material.dart';
import 'package:stacker_news/data/sn_api.dart';
import 'package:stacker_news/views/widgets/base_tab.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';
import 'package:stacker_news/views/widgets/sn_logo.dart';

class HomePage extends StatelessWidget {
  static const String id = 'home';

  // TODO: Clean up / Refactor this
  final List<Tab> tabs = const [
    Tab(
      icon: Icon(Icons.new_releases),
      child: SizedBox(width: 64, child: Center(child: Text('Top'))),
    ),
    Tab(
      icon: Icon(Icons.attach_money),
      child: SizedBox(width: 64, child: Center(child: Text('Bitcoin'))),
    ),
    Tab(
      icon: Icon(Icons.chat_bubble_sharp),
      child: SizedBox(width: 64, child: Center(child: Text('Nostr'))),
    ),
    Tab(
      icon: Icon(Icons.abc),
      child: SizedBox(width: 64, child: Center(child: Text('Tech'))),
    ),
    Tab(
      icon: Icon(Icons.merge_type),
      child: SizedBox(width: 64, child: Center(child: Text('Meta'))),
    ),
    Tab(
      icon: Icon(Icons.handshake_sharp),
      child: SizedBox(width: 64, child: Center(child: Text('Jobs'))),
    ),
  ];

  final List<Widget> tabViews = const [
    BaseTab(postType: PostType.top),
    BaseTab(postType: PostType.bitcoin),
    BaseTab(postType: PostType.nostr),
    BaseTab(postType: PostType.tech),
    BaseTab(postType: PostType.meta),
    BaseTab(postType: PostType.job),
  ];

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
        ),
        mainBody: TabBarView(children: tabViews),
      ),
    );
  }
}
