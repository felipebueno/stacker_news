import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/item.dart';
import 'package:stacker_news/widgets/post_item.dart';

class PostListUtils {
  static Widget buildInitialState(context) {
    return const Center(child: Text('Preparing to load posts'));
  }

  static Widget buildLoadingState(BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      );

  static Widget buildLoadedState(
    BuildContext context,
    List<Item> posts,
    bool isLoadingMore,
    bool isJobList,
  ) =>
      posts.isEmpty
          ? const Center(child: Text('No posts found'))
          : ListView.separated(
              itemBuilder: (context, index) {
                if (index == posts.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return PostItem(
                  posts[index],
                  idx: index + 1,
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: posts.length + (isLoadingMore ? 1 : 0),
            );

  static Widget buildErrorState(context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Error loading posts:'),
          Text(message),
        ],
      ),
    );
  }
}
