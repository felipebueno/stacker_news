import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/data/models/post_type.dart';
import 'package:stacker_news/data/sn_api.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/views/widgets/post_list.dart';
import 'package:stacker_news/views/widgets/post_list_error.dart';

class BaseTab extends StatefulWidget {
  final PostType postType;

  const BaseTab({
    Key? key,
    required this.postType,
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
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          final err = snapshot.error.toString();

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
