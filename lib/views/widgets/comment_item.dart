import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stacker_news/data/models/item.dart';
import 'package:stacker_news/views/pages/comments/comments_page.dart';
import 'package:stacker_news/views/widgets/user_button.dart';

class CommentItem extends StatelessWidget {
  final Item post;

  const CommentItem(
    this.post, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final link = textTheme.titleSmall?.copyWith(color: Colors.blue);
    final label = textTheme.titleSmall;

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
                UserButton(post.user),
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