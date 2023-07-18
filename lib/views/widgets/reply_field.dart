import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/data/sn_api.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/utils.dart';

import '../pages/new_post/text_with_preview.dart';

class ReplyField extends StatefulWidget {
  const ReplyField(
    this.item, {
    super.key,
    this.onCommentCreated,
  });

  final Post item;
  final VoidCallback? onCommentCreated;

  @override
  State<ReplyField> createState() => _ReplyFieldState();
}

class _ReplyFieldState extends State<ReplyField> {
  bool _busy = false;
  String _text = '';
  ValueKey _previewKey = ValueKey(Random().nextDouble());

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            TextWithPreview(
              key: ValueKey(_previewKey),
              onChanged: (text) {
                setState(() {
                  _text = text;
                });
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.reply),
              label: const Text('Reply'),
              onPressed: _text.trim().isEmpty
                  ? null
                  : () async {
                      try {
                        setState(() {
                          _busy = true;
                        });

                        final parentId = widget.item.id;

                        if (parentId == null) {
                          setState(() {
                            _busy = false;
                          });

                          throw Exception('Parent ID is null');
                        }

                        final comment = await locator<Api>().createComment(
                          parentId: parentId,
                          text: _text,
                        );

                        if (comment == null) {
                          throw Exception('Failed to create comment');
                        }

                        if (widget.onCommentCreated != null) {
                          widget.onCommentCreated!();
                        }

                        setState(() {
                          _text = '';
                          _previewKey = ValueKey(Random().nextDouble());
                        });
                      } catch (e, st) {
                        Utils.showException('Failed to create comment $e', st);
                      } finally {
                        setState(() {
                          _busy = false;
                        });
                      }
                    },
            ),
          ],
        ),
        if (_busy)
          Container(
            height: 248,
            color: Colors.black.withOpacity(.7),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Posting reply...'),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
