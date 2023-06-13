import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stacker_news/data/models/item.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/widgets/base_bloc_consumer.dart';
import 'package:stacker_news/widgets/posts/post_utils.dart';
import 'package:stacker_news/widgets/posts/show_posts/show_posts_bloc.dart';

class ShowPosts extends StatelessWidget {
  const ShowPosts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Item> posts = [];

    return BaseBlocConsumer<ShowPostsBloc, ShowPostsState>(
      onReady: () =>
          BlocProvider.of<ShowPostsBloc>(context).add(const GetShowPosts()),
      listener: (context, state) {
        if (state is ShowPostsError) {
          Utils.showInfo(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is ShowPostsInitial) {
          return PostListUtils.buildInitialState(context);
        } else if (state is ShowPostsLoading) {
          return PostListUtils.buildLoadingState(context);
        } else if (state is ShowPostsLoaded) {
          posts = state.posts;
          return PostListUtils.buildLoadedState(context, posts, false, false);
        } else if (state is ShowPostsError) {
          return PostListUtils.buildErrorState(context, state.message);
        } else if (state is ShowPostsLoadingMore) {
          return PostListUtils.buildLoadedState(context, posts, true, false);
        }
        return Container();
      },
    );
  }
}
