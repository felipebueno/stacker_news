import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stacker_news/colors.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/data/models/user.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/post/post_page.dart';
import 'package:stacker_news/views/widgets/cowboy_streak.dart';
import 'package:stacker_news/views/widgets/markdown_item.dart';
import 'package:stacker_news/views/widgets/reply_field.dart';
import 'package:stacker_news/views/widgets/stack_button.dart';

class BioHeader extends StatelessWidget {
  final User user;
  final int? idx;
  final VoidCallback? onCommentCreated;

  const BioHeader(
    this.user, {
    Key? key,
    this.idx,
    this.onCommentCreated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final link = textTheme.titleSmall?.copyWith(color: Colors.blue);
    final label = textTheme.titleSmall;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: CircleAvatar(
                  radius: 48,
                  child: CachedNetworkImage(
                    imageUrl: user.photoId == null
                        ? 'https://stacker.news/dorian400.jpg'
                        : 'https://snuploads.s3.amazonaws.com/${user.photoId}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user.atName,
                        style: textTheme.titleLarge,
                      ),
                      if (user.hideCowboyHat != true && user.streak != null)
                        CowboyStreak(streak: user.streak!),
                    ],
                  ),
                  Text(
                    '${user.satsStacked} sats stacked',
                    style: textTheme.titleLarge?.copyWith(
                      color: snYellow.withRed(160),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  StackButton(user.name ?? ''),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        PostPage.id,
                        arguments: Post(id: '${user.since}'),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          'stacking since: ',
                          style: label,
                        ),
                        Text(
                          user.since == null ? 'never' : '#${user.since}',
                          style: user.since == null ? label : link,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const SizedBox(width: 12),
                      Text(
                        'longest cowboy streak: ',
                        style: label,
                      ),
                      Text(
                        '${user.maxStreak ?? ''}',
                      ),
                    ],
                  ),
                  if (user.isContributor) const SizedBox(height: 8),
                  if (user.isContributor)
                    Row(
                      children: [
                        const SizedBox(width: 12),
                        const Icon(Icons.terminal, size: 16),
                        Text(
                          ' verified stacker.news contributor',
                          style: label,
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          TextButton(
            onPressed: () {
              Utils.showInfo('Not implemented yet');
            },
            child: Text(
              '${user.nItems} items',
              style: link,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: MarkdownItem(user.bio?.text),
          ),
          const SizedBox(height: 8.0),
          if (user.bio != null)
            ReplyField(
              user.bio!,
              onCommentCreated: onCommentCreated,
            ),
        ],
      ),
    );
  }
}
