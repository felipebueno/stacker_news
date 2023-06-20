import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stacker_news/data/sn_api.dart';
import 'package:stacker_news/views/widgets/base_tab.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';
import 'package:stacker_news/views/widgets/posts/bitcoin_posts/bitcon_posts.dart';
import 'package:stacker_news/views/widgets/posts/bitcoin_posts/bitcon_posts_bloc.dart';
import 'package:stacker_news/views/widgets/posts/job_posts/job_posts.dart';
import 'package:stacker_news/views/widgets/posts/job_posts/job_posts_bloc.dart';
import 'package:stacker_news/views/widgets/posts/nostr_posts/nostr_posts.dart';
import 'package:stacker_news/views/widgets/posts/nostr_posts/nostr_posts_bloc.dart';
import 'package:stacker_news/views/widgets/posts/top_posts/top_posts.dart';
import 'package:stacker_news/views/widgets/posts/top_posts/top_posts_bloc.dart';
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
    BaseTab<TopPostsBloc>(
      body: TopPosts(),
      onRefresh: GetTopPosts(),
      onMoreTap: GetMoreTopPosts(),
    ),
    BaseTab<BitcoinPostsBloc>(
      body: BitcoinPosts(),
      onRefresh: GetBitcoinPosts(),
      onMoreTap: GetMoreBitcoinPosts(),
    ),
    BaseTab<NostrPostsBloc>(
      body: NostrPosts(),
      onRefresh: GetNostrPosts(),
      onMoreTap: GetMoreNostrPosts(),
    ),
    BaseTab<JobPostsBloc>(
      body: JobPosts(),
      onRefresh: GetJobPosts(),
      onMoreTap: GetMoreJobPosts(),
    ),
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
        mainBody: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TopPostsBloc(
                TopPostsInitial(),
                PostRepository(),
              ),
            ),
            BlocProvider(
              create: (context) => BitcoinPostsBloc(
                BitcoinPostsInitial(),
                PostRepository(),
              ),
            ),
            BlocProvider(
              create: (context) => NostrPostsBloc(
                NostrPostsInitial(),
                PostRepository(),
              ),
            ),
            BlocProvider(
              create: (context) => JobPostsBloc(
                JobPostsInitial(),
                PostRepository(),
              ),
            ),
          ],
          child: TabBarView(
            children: tabViews,
          ),
        ),
      ),
    );
  }
}
