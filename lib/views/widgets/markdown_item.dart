import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown/src/util.dart';
import 'package:stacker_news/colors.dart';
import 'package:stacker_news/data/api.dart';
import 'package:stacker_news/utils.dart';

class MarkdownItem extends StatelessWidget {
  const MarkdownItem(String? text, {super.key}) : _text = text;

  final String? _text;

  // Example:
  // Input:
  //   '''
  //   https://i.imgur.com/9hwG6hZ.jpeg
  //   https://i.imgur.com/qsyaiwT.jpeg
  //   https://i.imgur.com/TQueRA8.jpeg
  //   '''
  // Output:
  //   '''
  //   ![Image 1](https://i.imgur.com/9hwG6hZ.jpeg)
  //   ![Image 2](https://i.imgur.com/qsyaiwT.jpeg)
  //   ![Image 3](https://i.imgur.com/TQueRA8.jpeg)
  //   '''
  String get _txtWithImages {
    if (_text == null) return '';

    final List<String> imageExtensions = [
      'jpeg',
      'jpg',
      'png',
      'gif',
      'bmp',
      'tiff',
      'svg'
    ];

    List<String> lines = _text.split('\n');
    List<String> markdownImages = [];

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();
      if (line.isNotEmpty) {
        // Check if the line ends with one of the imageExtensions
        bool isImage = imageExtensions.any((ext) =>
            line.toLowerCase().endsWith('.$ext') ||
            line.toLowerCase().startsWith('https://imgprxy.stacker.news/'));

        if (isImage) {
          // If it is an image link, transform it to Markdown image syntax
          markdownImages.add('![Image ${i + 1}]($line)');
        } else {
          // If it is not an image link, keep the line as is
          markdownImages.add(line);
        }
      }
    }
    // Join the list into a single string with new lines
    return markdownImages.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: _txtWithImages,
      styleSheet: MarkdownStyleSheet(
        blockquoteDecoration: BoxDecoration(
          color: SNColors.primary.withAlpha(32),
        ),
      ),
      shrinkWrap: true,
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        [
          md.EmojiSyntax(),
          md.AutolinkExtensionSyntax(),
          ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
          SNAutolinkExtensionSyntax(),
        ],
      ),
      onTapLink: (_, href, __) {
        if (href == null) {
          return;
        }

        Utils.launchURL(href);
      },
    );
  }
}

/// Matches autolinks like `@username`.
class SNAutolinkExtensionSyntax extends md.InlineSyntax {
  static const _atUsernamePattern = r'@([a-zA-Z0-9_-]+)';

  SNAutolinkExtensionSyntax()
      : super(
          '($_atUsernamePattern)',
          caseSensitive: false,
        );

  @override
  bool tryMatch(md.InlineParser parser, [int? startMatchPos]) {
    startMatchPos ??= parser.pos;
    final startMatch = pattern.matchAsPrefix(parser.source, startMatchPos);
    if (startMatch == null) {
      return false;
    }

    // When it is a link and it is not preceded by `*`, `_`, `~`, `(`, or `>`,
    // it is invalid. See
    // https://github.github.com/gfm/#extended-autolink-path-validation.
    if (startMatch[1] != null && parser.pos > 0) {
      final precededBy = String.fromCharCode(parser.charAt(parser.pos - 1));
      const validPrecedingChars = {' ', '*', '_', '~', '(', '>'};
      if (validPrecedingChars.contains(precededBy) == false) {
        return false;
      }
    }

    parser.writeText();
    return onMatch(parser, startMatch);
  }

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final consumeLength = match.match.length;

    final text = match.match.substring(0, consumeLength);

    final destination = '$baseUrl/${text.replaceAll('@', '')}?isUser=true';

    final anchor = md.Element.text('a', text)
      ..attributes['href'] = Uri.encodeFull(destination);

    parser
      ..addNode(anchor)
      ..consume(consumeLength);

    return true;
  }
}
