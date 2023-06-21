import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stacker_news/colors.dart';
import 'package:stacker_news/utils.dart';

class MarkdownItem extends StatelessWidget {
  const MarkdownItem(String? text, {super.key}) : _text = text;

  final String? _text;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: _text ?? '',
      styleSheet: MarkdownStyleSheet(
        blockquoteDecoration: BoxDecoration(
          color: snYellow.withAlpha(32),
        ),
      ),
      onTapLink: (_, href, __) {
        Utils.launchURL(href);
      },
    );
  }
}
