import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stacker_news/data/models/item.dart';
import 'package:stacker_news/pages/comments/comments_page.dart';

class CommentItem extends StatelessWidget {
  final Item post;

  const CommentItem(
    this.post, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final TextStyle link = textTheme.titleSmall?.copyWith(
          color: Colors.blue,
        ) ??
        const TextStyle();

    final TextStyle label = textTheme.titleSmall ?? const TextStyle();

    return InkWell(
      onTap: () {
        if (post.ncomments == null || post.ncomments == 0) return;

        Navigator.of(context).pushNamed(
          PostComments.id,
          arguments: post,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 24.0,
          right: 8.0,
          top: 8.0,
          bottom: 8.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  post.isJob == true ? '${post.company}' : '${post.sats} sats',
                  style: label,
                ),
                Text(
                  post.isJob == true
                      ? '${(post.remote == true && post.location == '') ? 'Remote' : post.location}'
                      : '${post.ncomments} comments',
                  style: label,
                ),
                Text(
                  '@${post.user?.name}',
                  style: link,
                ),
                Text(
                  post.timeAgo,
                  style: label,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: MarkdownBody(data: post.text ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}
