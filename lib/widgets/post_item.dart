import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stacker_news/data/models/item.dart';
import 'package:stacker_news/pages/comments/comments.dart';
import 'package:stacker_news/utils.dart';

class PostItem extends StatelessWidget {
  final Item post;
  final int? idx;
  final bool isCommentsPage;
  final bool isJobList;

  const PostItem(
    this.post, {
    Key? key,
    this.idx,
    this.isCommentsPage = false,
    this.isJobList = false,
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
      onTap: isCommentsPage
          ? post.url != null && post.url != ''
              ? () {
                  Utils.launchURL(post.url!);
                }
              : null
          : () {
              Navigator.of(context).pushNamed(
                PostComments.id,
                arguments: post,
              );
            },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            if (!isCommentsPage)
              SizedBox(
                width: 32.0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Text(
                    '$idx.',
                    textAlign: TextAlign.end,
                    style: textTheme.titleSmall,
                  ),
                ),
              ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title ?? '',
                    style: textTheme.titleMedium,
                  ),
                  if (post.url != null && post.url != '')
                    TextButton(
                      child: Text(
                        post.url!,
                        style: link,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        Utils.launchURL(post.url!);
                      },
                    ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        post.isJob == true
                            ? '${post.company}'
                            : '${post.sats} sats',
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
                  isCommentsPage && post.text != null && post.text != ''
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: MarkdownBody(data: post.text!),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
