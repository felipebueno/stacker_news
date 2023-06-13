import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stacker_news/data/models/item.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/widgets/base_bloc_consumer.dart';
import 'package:stacker_news/widgets/posts/nostr_posts/nostr_posts_bloc.dart';
import 'package:stacker_news/widgets/posts/post_utils.dart';

class NostrPosts extends StatelessWidget {
  const NostrPosts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Item> posts = [];

    return BaseBlocConsumer<NostrPostsBloc, NostrPostsState>(
      onReady: () =>
          BlocProvider.of<NostrPostsBloc>(context).add(const GetNostrPosts()),
      listener: (context, state) {
        if (state is NostrPostsError) {
          Utils.showInfo(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is NostrPostsInitial) {
          return PostListUtils.buildInitialState(context);
        } else if (state is NostrPostsLoading) {
          return PostListUtils.buildLoadingState(context);
        } else if (state is NostrPostsLoaded) {
          posts = state.posts;
          return PostListUtils.buildLoadedState(context, posts, false, false);
        } else if (state is NostrPostsError) {
          return PostListUtils.buildErrorState(context, state.message);
        } else if (state is NostrPostsLoadingMore) {
          return PostListUtils.buildLoadedState(context, posts, true, false);
        }
        return Container();
      },
    );
  }
}
