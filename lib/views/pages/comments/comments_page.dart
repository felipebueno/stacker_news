import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/item.dart';
import 'package:stacker_news/data/sn_api.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/widgets/comment_item.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';
import 'package:stacker_news/views/widgets/post_item.dart';
import 'package:stacker_news/views/widgets/post_list_error.dart';

class CommentsPage extends StatelessWidget {
  static const String id = 'comments';

  const CommentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)?.settings.arguments as Item;

    return GenericPageScaffold(
      title: item.pageTitle ?? 'Comments',
      body: CommentList(item: item),
    );
  }
}

class CommentList extends StatelessWidget {
  const CommentList({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Api().fetchItem(item),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          final err = snapshot.error.toString();
          Utils.showError(context, err);
          return PostListError(err);
        }

        final item = snapshot.data as Item;

        final comments = item.comments ?? [];

        return ListView.separated(
          itemBuilder: (context, index) {
            if (index == 0) {
              return PostItem(item, isCommentsPage: true);
            }

            return CommentItem(comments[index - 1]);
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: comments.length + 1,
        );
      },
    );
  }
}
