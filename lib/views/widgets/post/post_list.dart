import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/data/models/sub.dart';
import 'package:stacker_news/data/sn_api_client.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/views/widgets/post/post_item.dart';

class PostList extends StatefulWidget {
  const PostList(
    this.posts, {
    required this.sub,
    this.sort = 'LIT',
    this.type,
    this.by,
    this.when,
    this.from,
    this.to,
    super.key,
  });

  final List<Post> posts;
  final Sub sub;
  final String sort;
  final String? type;
  final String? by;
  final String? when;
  final DateTime? from;
  final DateTime? to;

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final _scrollController = ScrollController();
  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();

    if (widget.sub.name != 'jobs') {
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          setState(() {
            _loadingMore = true;
          });

          final posts = await locator<SNApiClient>().fetchMorePostsBySub(
            widget.sub.name,
            sort: widget.sort,
            type: widget.type,
            by: widget.by,
            when: widget.when,
            from: widget.from,
            to: widget.to,
          );

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
                sub: widget.sub,
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
          sub: widget.sub,
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: widget.posts.length,
    );
  }
}
