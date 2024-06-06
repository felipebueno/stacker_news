import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacker_news/colors.dart';
import 'package:stacker_news/data/api.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/data/models/post_type.dart';
import 'package:stacker_news/data/models/session.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/post/post_page.dart';
import 'package:stacker_news/views/widgets/comment_item.dart';
import 'package:stacker_news/views/widgets/markdown_item.dart';
import 'package:stacker_news/views/widgets/user_button.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final int? idx;
  final bool isCommentsPage;
  final PostType? postType;

  const PostItem(
    this.post, {
    super.key,
    this.idx,
    this.postType,
    this.isCommentsPage = false,
  });

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late Post _post = widget.post;

  Widget _buildNormalItem({bool showIdx = false}) {
    final textTheme = Theme.of(context).textTheme;
    final link = textTheme.titleSmall?.copyWith(color: Colors.blue);
    final label = textTheme.titleSmall;
    final item = _post.item ?? _post;

    return InkWell(
      onTap: widget.isCommentsPage
          ? item.url != null && item.url != ''
              ? () {
                  Utils.launchURL(item.url!);
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
            if (widget.isCommentsPage && item.id != null && item.id != '')
              SizedBox(
                width: 32.0,
                child: MaybeZapButton(
                  item.id!,
                  meSats: item.meSats,
                  onZapped: (int amount) {
                    setState(() {
                      if (_post.item != null) {
                        _post = _post.copyWith(
                          item: _post.item!.copyWith(
                            sats: (item.sats ?? 0) + amount,
                          ),
                        );
                      } else {
                        _post = _post.copyWith(
                          sats: (item.sats ?? 0) + amount,
                        );
                      }
                    });
                  },
                ),
              ),
            if (!widget.isCommentsPage)
              SizedBox(
                width: 32.0,
                child: Column(
                  children: [
                    if (showIdx)
                      Text(
                        '${widget.idx}.',
                        textAlign: TextAlign.end,
                        style: textTheme.titleSmall,
                      ),
                    if (item.id != null && item.id != '')
                      MaybeZapButton(
                        item.id!,
                        onZapped: (int amount) {
                          setState(() {
                            _post = item.copyWith(
                              sats: (item.sats ?? 0) + amount,
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
                  if (item.title != null && item.title != '')
                    Text(
                      item.title!,
                      style: textTheme.titleMedium,
                    ),
                  if (item.url != null && item.url != '')
                    TextButton(
                      child: Text(
                        item.url!,
                        style: link,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        Utils.launchURL(item.url!);
                      },
                    ),
                  if (widget.isCommentsPage &&
                      item.text != null &&
                      item.text != '')
                    MarkdownItem(item.text),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Text(
                          item.isJob == true
                              ? '${item.company}'
                              : '${item.sats} sats',
                          style: label,
                        ),
                      ),
                      Text(
                        item.isJob == true
                            ? '${(item.remote == true && item.location == '') ? 'Remote' : item.location}'
                            : '${item.ncomments} comments',
                        style: label,
                      ),
                      Text(
                        item.timeAgo,
                        style: label,
                        textAlign: TextAlign.end,
                      )
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [UserButton(item.user)],
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

  Widget _buildNotificationItem() {
    String txt = '';
    Color? color;

    switch (_post.typeName) {
      case 'FollowActivity':
        txt =
            'a stacker you subscribe to ${_post.item?.parentId != null ? 'commented' : 'posted'}';

        color = SNColors.info;

        break;
      case 'Votification':
        txt =
            'your ${_post.item?.title == null ? 'comment' : 'post'} stacked ${_post.earnedSats} sats';

        color = SNColors.success;

        break;
      case 'Reply':
        txt = 'you got a reply';

        color = SNColors.info;

        break;
      case 'WithdrawlPaid':
        txt = '${_post.earnedSats} sats where withdrawn from your account';

        color = SNColors.info;

        break;

      default:
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            kDebugMode ? '${_post.typeName} - $txt' : txt,
            style: const TextStyle().copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (_post.item != null)
          _post.item != null && _post.item!.title == null
              ? CommentItem(_post.item!)
              : _buildNormalItem(showIdx: false),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.postType == PostType.notifications
        ? _buildNotificationItem()
        : _buildNormalItem();
  }
}

class MaybeZapButton extends StatefulWidget {
  final String _id;
  final int? _meSats;
  final void Function(int)? _onZapped;

  const MaybeZapButton(
    String id, {
    int? meSats,
    void Function(int)? onZapped,
    super.key,
  })  : _id = id,
        _meSats = meSats,
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
                  colorFilter: ColorFilter.mode(
                    SNColors.getColor(widget._meSats) ?? Colors.grey,
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
