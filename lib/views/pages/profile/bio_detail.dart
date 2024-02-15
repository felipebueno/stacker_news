import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/user.dart';
import 'package:stacker_news/views/pages/profile/bio_header.dart';
import 'package:stacker_news/views/widgets/comment_item.dart';

class BioDetail extends StatelessWidget {
  const BioDetail(
    this.user, {
    super.key,
    this.onCommentCreated,
  });

  final User user;
  final VoidCallback? onCommentCreated;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        if (index == 0) {
          return BioHeader(
            user,
            onCommentCreated: onCommentCreated,
          );
        }

        return CommentItem((user.bio?.comments ?? [])[index - 1]);
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: (user.bio?.comments ?? []).length + 1,
    );
  }
}
