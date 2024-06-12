import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/data/sn_api_client.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';
import 'package:stacker_news/views/widgets/post/comment_item.dart';
import 'package:stacker_news/views/widgets/post/post_item.dart';
import 'package:stacker_news/views/widgets/post/post_list_error.dart';
import 'package:stacker_news/views/widgets/reply_field.dart';

class PostPage extends StatefulWidget {
  static const String id = 'post';

  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Future<Post>? _postFuture;
  Post? _post;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Fetch route arguments only once
    // Fix https://github.com/felipebueno/stacker_news/issues/18
    // TODO: Apply the fix on all pages and widgets that are using ModdalRoute
    if (!_isInitialized) {
      final post = ModalRoute.of(context)?.settings.arguments as Post;
      _post = post;
      _postFuture = _fetchPostDetails(post.id ?? '');
      _isInitialized = true;
    }
  }

  Future<Post> _fetchPostDetails(String id) async {
    return await locator<SNApiClient>().fetchPostDetails(id);
  }

  @override
  Widget build(BuildContext context) {
    return GenericPageScaffold(
      title: _post == null ? 'Loading...' : _post!.pageTitle ?? '#${_post!.id}',
      body: _post == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder(
              future: _postFuture,
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
                    setState(() {
                      _postFuture = _fetchPostDetails(_post!.id ?? '');
                    });
                  },
                  child: ListView.separated(
                    addAutomaticKeepAlives: true,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            PostItem(item, isCommentsPage: true),
                            ReplyField(
                              item,
                              onCommentCreated: () {
                                setState(() {
                                  _postFuture =
                                      _fetchPostDetails(_post!.id ?? '');
                                });
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
