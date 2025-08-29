import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/data/models/post_type.dart';
import 'package:stacker_news/data/sn_api_client.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/views/widgets/post/post_item.dart';

class PostList extends StatefulWidget {
  const PostList(
    this.posts, {
    required this.postType,
    super.key,
  });

  final List<Post> posts;
  final PostType postType;

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final _scrollController = ScrollController();
  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();

    if (widget.postType != PostType.jobs) {
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          setState(() {
            _loadingMore = true;
          });

          final posts = await locator<SNApiClient>().fetchMorePosts(widget.postType);

          setState(() {
            widget.posts.addAll(posts);
            _loadingMore = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      itemBuilder: (context, index) {
        if (((index + 1) == widget.posts.length) && _loadingMore) {
          return Column(
            children: [
              PostItem(
                widget.posts[index],
                idx: index + 1,
                postType: widget.postType,
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
        }

        return PostItem(
          widget.posts[index],
          idx: index + 1,
          postType: widget.postType,
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: widget.posts.length,
    );
  }
}
