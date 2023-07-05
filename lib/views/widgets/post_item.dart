import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/data/models/post_type.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/post/post_page.dart';
import 'package:stacker_news/views/widgets/markdown_item.dart';
import 'package:stacker_news/views/widgets/user_button.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final int? idx;
  final bool isCommentsPage;
  final bool isJobList;
  final PostType? postType;

  const PostItem(
    this.post, {
    Key? key,
    this.idx,
    this.postType,
    this.isCommentsPage = false,
    this.isJobList = false,
  }) : super(key: key);

  Widget _buildNormalItem(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final link = textTheme.titleSmall?.copyWith(color: Colors.blue);
    final label = textTheme.titleSmall;

    return InkWell(
      onTap: isCommentsPage
          ? post.url != null && post.url != ''
              ? () {
                  Utils.launchURL(post.url!);
                }
              : null
          : () {
              Navigator.of(context).pushNamed(
                PostPage.id,
                arguments: post,
              );
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          children: [
            if (!isCommentsPage)
              SizedBox(
                width: 32.0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Text(
                    '$idx.',
                    textAlign: TextAlign.end,
                    style: textTheme.titleSmall,
                  ),
                ),
              ),
            if (!isCommentsPage) const SizedBox(width: 4),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  if (post.title != null && post.title != '')
                    Text(
                      post.title!,
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
                  if (isCommentsPage && post.text != null && post.text != '')
                    MarkdownItem(post.text),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context) {
    return ListTile(
      title: Text('$post'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return postType == PostType.notifications
        ? _buildNotificationItem(context)
        : _buildNormalItem(context);
  }
}
