import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/post_type.dart';
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
        ),
        mainBody: TabBarView(children: tabViews),
      ),
    );
  }
}
