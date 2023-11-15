import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacker_news/data/api.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/data/models/post_type.dart';
import 'package:stacker_news/data/models/session.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/post/post_page.dart';
import 'package:stacker_news/views/widgets/markdown_item.dart';
import 'package:stacker_news/views/widgets/user_button.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final int? idx;
  final bool isCommentsPage;
  final PostType? postType;

  const PostItem(
    this.post, {
    Key? key,
    this.idx,
    this.postType,
    this.isCommentsPage = false,
  }) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late Post _post;

  @override
  void initState() {
    super.initState();

    _post = widget.post;
  }

  Widget _buildNormalItem(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final link = textTheme.titleSmall?.copyWith(color: Colors.blue);
    final label = textTheme.titleSmall;

    return InkWell(
      onTap: widget.isCommentsPage
          ? _post.url != null && _post.url != ''
              ? () {
                  Utils.launchURL(_post.url!);
                }
              : null
          : () {
              Navigator.of(context).pushNamed(
                PostPage.id,
                arguments: _post,
              );
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          children: [
            if (widget.isCommentsPage && _post.id != null && _post.id != '')
              SizedBox(
                width: 32.0,
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
            if (!widget.isCommentsPage)
              SizedBox(
                width: 32.0,
                child: Column(
                  children: [
                    Text(
                      '${widget.idx}.',
                      textAlign: TextAlign.end,
                      style: textTheme.titleSmall,
                    ),
                    if (_post.id != null && _post.id != '')
                      MaybeZapButton(
                        _post.id!,
                        onZapped: (int amount) {
                          setState(() {
                            _post = _post.copyWith(
                              sats: (_post.sats ?? 0) + amount,
                            );
                          });
                        },
                      ),
                  ],
                ),
              ),
            const SizedBox(width: 4),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  if (_post.title != null && _post.title != '')
                    Text(
                      _post.title!,
                      style: textTheme.titleMedium,
                    ),
                  if (_post.url != null && _post.url != '')
                    TextButton(
                      child: Text(
                        _post.url!,
                        style: link,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        Utils.launchURL(_post.url!);
                      },
                    ),
                  if (widget.isCommentsPage &&
                      _post.text != null &&
                      _post.text != '')
                    MarkdownItem(_post.text),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        _post.isJob == true
                            ? '${_post.company}'
                            : '${_post.sats} sats',
                        style: label,
                      ),
                      Text(
                        _post.isJob == true
                            ? '${(_post.remote == true && _post.location == '') ? 'Remote' : _post.location}'
                            : '${_post.ncomments} comments',
                        style: label,
                      ),
                      Text(
                        _post.timeAgo,
                        style: label,
                        textAlign: TextAlign.end,
                      )
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [UserButton(_post.user)],
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
      title: Text('$_post'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.postType == PostType.notifications
        ? _buildNotificationItem(context)
        : _buildNormalItem(context);
  }
}

class MaybeZapButton extends StatefulWidget {
  final String _id;
  final void Function(int)? _onZapped;

  const MaybeZapButton(String id, {void Function(int)? onZapped, super.key})
      : _id = id,
        _onZapped = onZapped;

  @override
  State<MaybeZapButton> createState() => _MaybeZapButtonState();
}

class _MaybeZapButtonState extends State<MaybeZapButton> {
  final _busy = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Utils.getSession(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data is Session) {
          return Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  try {
                    _busy.value = true;
                    final amount = await locator<Api>().zapPost(widget._id);

                    if (amount == null) return;

                    Utils.showInfo('Zapped $amount sats');

                    widget._onZapped?.call(amount);
                  } catch (e, st) {
                    Utils.showException('Error zapping $e', st);
                  } finally {
                    _busy.value = false;
                  }
                },
                icon: SvgPicture.asset(
                  'assets/upvote.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _busy,
                builder: (context, busy, child) {
                  if (!busy) {
                    return const SizedBox.shrink();
                  }

                  return const Center(
                    child: SizedBox(
                      width: 12.0,
                      height: 12.0,
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              )
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
