import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stacker_news/data/models/user.dart';
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

    final TextStyle label = textTheme.titleSmall ?? const TextStyle();

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 64,
                backgroundImage: NetworkImage(
                  user.photoId == null
                      ? 'https://stacker.news/dorian400.jpg'
                      : 'https://snuploads.s3.amazonaws.com/${user.photoId}',
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.atName,
                    style: textTheme.titleMedium,
                  ),
                  Text(
                    '${user.stacked} stacked',
                    style: textTheme.titleMedium,
                  ),
                  StackButton(user.name ?? ''),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'stacking since: ${user.since}',
                      style: textTheme.titleMedium,
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
            child: MarkdownBody(data: user.bio!.text!),
          )
        ],
      ),
    );
  }
}
