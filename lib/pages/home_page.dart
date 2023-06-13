import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stacker_news/data/post_repository.dart';
import 'package:stacker_news/widgets/base_tab.dart';
import 'package:stacker_news/widgets/generic_page_scaffold.dart';
import 'package:stacker_news/widgets/posts/bitcoin_posts/bitcon_posts.dart';
import 'package:stacker_news/widgets/posts/bitcoin_posts/bitcon_posts_bloc.dart';
import 'package:stacker_news/widgets/posts/job_posts/job_posts.dart';
import 'package:stacker_news/widgets/posts/job_posts/job_posts_bloc.dart';
import 'package:stacker_news/widgets/posts/show_posts/show_posts.dart';
import 'package:stacker_news/widgets/posts/show_posts/show_posts_bloc.dart';
import 'package:stacker_news/widgets/posts/top_posts/top_posts.dart';
import 'package:stacker_news/widgets/posts/top_posts/top_posts_bloc.dart';
import 'package:stacker_news/widgets/sn_logo.dart';

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
    BaseTab<ShowPostsBloc>(
      body: ShowPosts(),
      onRefresh: GetShowPosts(),
      onMoreTap: GetMoreShowPosts(),
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
              create: (context) => ShowPostsBloc(
                ShowPostsInitial(),
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
