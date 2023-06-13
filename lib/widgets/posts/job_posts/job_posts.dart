import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stacker_news/data/models/item.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/widgets/base_bloc_consumer.dart';
import 'package:stacker_news/widgets/posts/job_posts/job_posts_bloc.dart';
import 'package:stacker_news/widgets/posts/post_utils.dart';

class JobPosts extends StatelessWidget {
  const JobPosts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Item> posts = [];

    return BaseBlocConsumer<JobPostsBloc, JobPostsState>(
      onReady: () =>
          BlocProvider.of<JobPostsBloc>(context).add(const GetJobPosts()),
      listener: (context, state) {
        if (state is JobPostsError) {
          Utils.showInfo(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is JobPostsInitial) {
          return PostListUtils.buildInitialState(context);
        } else if (state is JobPostsLoading) {
          return PostListUtils.buildLoadingState(context);
        } else if (state is JobPostsLoaded) {
          posts = state.posts;
          return PostListUtils.buildLoadedState(context, posts, false, true);
        } else if (state is JobPostsError) {
          return PostListUtils.buildErrorState(context, state.message);
        } else if (state is JobPostsLoadingMore) {
          return PostListUtils.buildLoadedState(context, posts, true, true);
        }
        return Container();
      },
    );
  }
}
