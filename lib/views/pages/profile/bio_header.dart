import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stacker_news/colors.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/data/models/user.dart';
import 'package:stacker_news/views/pages/post/post_page.dart';
import 'package:stacker_news/views/widgets/cowboy_streak.dart';
import 'package:stacker_news/views/widgets/markdown_item.dart';
import 'package:stacker_news/views/widgets/reply_field.dart';
import 'package:stacker_news/views/widgets/stack_button.dart';

class BioHeader extends StatelessWidget {
  final User user;
  final int? idx;

  const BioHeader(
    this.user, {
    Key? key,
    this.idx,
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
                    '${user.stacked} stacked',
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
                          '#${user.since}',
                          style: link,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${user.nItems} posts',
                style: label,
              ),
              Text(
                '${user.nComments} comments',
                style: label,
              ),
              Text(
                '${user.nBookmarks} bookmarks',
                style: label,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: MarkdownItem(user.bio?.text),
          ),
          const SizedBox(height: 8.0),
          const ReplyField(),
        ],
      ),
    );
  }
}
