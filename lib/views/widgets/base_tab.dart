import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/data/models/post_type.dart';
import 'package:stacker_news/data/sn_api.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/widgets/post_item.dart';
import 'package:stacker_news/views/widgets/post_list_error.dart';

class BaseTab extends StatefulWidget {
  final PostType postType;
  final dynamic onMoreTap;

  const BaseTab({
    Key? key,
    required this.postType,
    this.onMoreTap,
  }) : super(key: key);

  @override
  State<BaseTab> createState() => _BaseTabState();
}

class _BaseTabState extends State<BaseTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final Api _api = locator<Api>();

  Future<List<Post>> _fetchInitialPosts() async =>
      await _api.fetchInitialPosts(widget.postType);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
      future: _fetchInitialPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          final err = snapshot.error.toString();
          Utils.showError(err);

          return PostListError(err);
        }

        final posts = snapshot.data as List<Post>;

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: posts.isEmpty
                    ? const Center(child: Text('No posts found'))
                    : PostList(
                        posts,
                        postType: widget.postType,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}

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

    if (widget.postType != PostType.job) {
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            _loadingMore = true;
          });

          final posts = await locator<Api>().fetchMorePosts(widget.postType);

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
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: widget.posts.length,
    );
  }
}
