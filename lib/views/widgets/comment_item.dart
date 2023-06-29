import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/views/pages/post/post_page.dart';
import 'package:stacker_news/views/widgets/markdown_item.dart';
import 'package:stacker_news/views/widgets/user_button.dart';

class CommentItem extends StatelessWidget {
  final Post post;

  const CommentItem(
    this.post, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final label = textTheme.titleSmall;

    return InkWell(
      onTap: () {
        if (post.ncomments == null || post.ncomments == 0) return;

        Navigator.of(context).pushNamed(
          PostPage.id,
          arguments: post,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 24.0,
          right: 8.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.text != null && post.text != '') MarkdownItem(post.text),
            if (post.text != null && post.text != '')
              const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '${post.sats} sats',
                  style: label,
                ),
                Text(
                  '${post.ncomments} comments',
                  style: label,
                ),
                Text(
                  post.timeAgo,
                  style: label,
                  textAlign: TextAlign.end,
                )
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [UserButton(post.user)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
