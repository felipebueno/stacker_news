import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/data/sn_api.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/widgets/comment_item.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';
import 'package:stacker_news/views/widgets/post_item.dart';
import 'package:stacker_news/views/widgets/post_list_error.dart';

class PostPage extends StatefulWidget {
  static const String id = 'post';

  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Future<Post> _fetchPostDetails(String id) async {
    return await locator<Api>().fetchPostDetails(id);
  }

  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)?.settings.arguments as Post;

    return GenericPageScaffold(
      title: post.pageTitle ?? '#${post.id}',
      body: FutureBuilder(
        future: _fetchPostDetails(post.id ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            final err = snapshot.error.toString();
            Utils.showError(context, err);
            return PostListError(err);
          }

          final item = snapshot.data as Post;

          final comments = item.comments ?? [];

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView.separated(
              itemBuilder: (context, index) {
                if (index == 0) {
                  return PostItem(item, isCommentsPage: true);
                }

                return CommentItem(comments[index - 1]);
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: comments.length + 1,
            ),
          );
        },
      ),
    );
  }
}
