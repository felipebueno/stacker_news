import 'package:flutter/material.dart';
import 'package:stacker_news/data/api.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/widgets/comment_item.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';
import 'package:stacker_news/views/widgets/post_item.dart';
import 'package:stacker_news/views/widgets/post_list_error.dart';
import 'package:stacker_news/views/widgets/reply_field.dart';

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
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            final err = snapshot.error.toString();
            Utils.showError(err);

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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      PostItem(item, isCommentsPage: true),
                      ReplyField(
                        item,
                        onCommentCreated: () {
                          setState(() {});
                        },
                      ),
                    ],
                  );
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
