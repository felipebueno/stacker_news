import 'package:flutter/material.dart';

import '../pages/new_post/text_with_preview.dart';

class ReplyField extends StatefulWidget {
  const ReplyField({super.key});

  @override
  State<ReplyField> createState() => _ReplyFieldState();
}

class _ReplyFieldState extends State<ReplyField> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            const TextWithPreview(),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.reply),
              label: const Text('Reply'),
              onPressed: () async {
                setState(() {
                  _busy = true;
                });

                await Future.delayed(Duration(seconds: 2));

                setState(() {
                  _busy = false;
                });
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
