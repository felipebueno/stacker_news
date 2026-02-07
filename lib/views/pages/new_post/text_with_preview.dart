import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:stacker_news/utils.dart';

class TextWithPreview extends StatefulWidget {
  const TextWithPreview({
    super.key,
    this.label,
    this.onChanged,
  });

  final String? label;
  final ValueChanged<String>? onChanged;

  @override
  State<TextWithPreview> createState() => _TextWithPreviewState();
}

class _TextWithPreviewState extends State<TextWithPreview> {
  int _selectedTab = 0;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _textController.addListener(() {
      widget.onChanged?.call(_textController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _selectedTab = 0;
                  });
                },
                child: const Text('Write'),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _selectedTab = 1;
                  });
                },
                child: const Text('Preview'),
              ),
            ),
          ],
        ),
        if (_selectedTab == 0)
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: widget.label ?? 'Text',
              suffixIcon: IconButton(
                onPressed: () {
                  Utils.launchURL(
                    'https://guides.github.com/features/mastering-markdown/',
                  );
                },
                icon: const Icon(Icons.code),
              ),
            ),
            minLines: 6,
            maxLines: 12,
          ),
        if (_selectedTab == 1)
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
            height: 176,
            child: Markdown(
              data: _textController.text,
              shrinkWrap: true,
            ),
          ),
      ],
    );
  }
}
