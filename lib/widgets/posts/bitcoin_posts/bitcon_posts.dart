import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stacker_news/data/models/item.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/widgets/base_bloc_consumer.dart';
import 'package:stacker_news/widgets/posts/post_utils.dart';

import 'bitcon_posts_bloc.dart';

class BitcoinPosts extends StatelessWidget {
  const BitcoinPosts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Item> posts = [];

    return BaseBlocConsumer<BitcoinPostsBloc, BitcoinPostsState>(
      onReady: () => BlocProvider.of<BitcoinPostsBloc>(context)
          .add(const GetBitcoinPosts()),
      listener: (context, state) {
        if (state is BitcoinPostsError) {
          Utils.showInfo(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is BitcoinPostsInitial) {
          return PostListUtils.buildInitialState(context);
        } else if (state is BitcoinPostsLoading) {
          return PostListUtils.buildLoadingState(context);
        } else if (state is BitcoinPostsLoaded) {
          posts = state.posts;
          return PostListUtils.buildLoadedState(context, posts, false, false);
        } else if (state is BitcoinPostsError) {
          return PostListUtils.buildErrorState(context, state.message);
        } else if (state is BitcoinPostsLoadingMore) {
          return PostListUtils.buildLoadedState(context, posts, true, false);
        }
        return Container();
      },
    );
  }
}
