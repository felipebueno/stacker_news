import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/views/pages/post/post_page.dart';
import 'package:stacker_news/views/widgets/markdown_item.dart';
import 'package:stacker_news/views/widgets/post_item.dart';
import 'package:stacker_news/views/widgets/user_button.dart';

class CommentItem extends StatefulWidget {
  final Post post;

  const CommentItem(
    this.post, {
    super.key,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  late Post _post;

  @override
  void initState() {
    super.initState();

    _post = widget.post;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final label = textTheme.titleSmall;

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          PostPage.id,
          arguments: _post,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          right: 8.0,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40.0,
              child: MaybeZapButton(
                _post.id!,
                onZapped: (int amount) {
                  setState(() {
                    _post = _post.copyWith(
                      sats: (_post.sats ?? 0) + amount,
                    );
                  });
                },
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  if (_post.text != null && _post.text != '')
                    MarkdownItem(_post.text),
                  if (_post.text != null && _post.text != '')
                    const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '${_post.sats} sats',
                        style: label,
                      ),
                      Text(
                        '${_post.ncomments} comments',
                        style: label,
                      ),
                      Text(
                        _post.timeAgo,
                        style: label,
                        textAlign: TextAlign.end,
                      )
                    ],
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Reply', style: textTheme.bodySmall),
                        UserButton(_post.user),
                      ],
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
}
