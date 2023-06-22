import 'package:flutter/material.dart';
import 'package:stacker_news/data/sn_api.dart';
import 'package:stacker_news/views/widgets/base_tab.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';
import 'package:stacker_news/views/widgets/sn_logo.dart';

class HomePage extends StatelessWidget {
  static const String id = 'home';

  final List<Tab> tabs = const [
    Tab(icon: Icon(Icons.new_releases), text: 'Top'),
    Tab(icon: Icon(Icons.attach_money), text: 'Bitcoin'),
    Tab(icon: Icon(Icons.chat_bubble_sharp), text: 'Nostr'),
    Tab(icon: Icon(Icons.handshake_sharp), text: 'Jobs'),
  ];

  final List<Widget> tabViews = const [
    BaseTab(postType: PostType.top),
    BaseTab(postType: PostType.bitcoin),
    BaseTab(postType: PostType.nostr),
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
          bottom: TabBar(tabs: tabs),
        ),
        mainBody: TabBarView(children: tabViews),
      ),
    );
  }
}
