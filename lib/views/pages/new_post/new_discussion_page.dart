import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stacker_news/data/sn_api_client.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/new_post/new_post_footer.dart';
import 'package:stacker_news/views/pages/new_post/text_with_preview.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';

class NewDiscussionPage extends StatefulWidget {
  static const String id = 'new_discussion';

  const NewDiscussionPage({super.key});

  @override
  State<NewDiscussionPage> createState() => _NewDiscussionPageState();
}

class _NewDiscussionPageState extends State<NewDiscussionPage> {
  bool _busy = false;
  String? _selectedSub;
  String _text = '';
  final _titleController = TextEditingController();
  ValueKey _previewKey = ValueKey(Random().nextDouble());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args = ModalRoute.of(context)!.settings.arguments as String?;
      if (args != null) {
        setState(() {
          _selectedSub = args;
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GenericPageScaffold(
      title: '$_selectedSub Discussion',
      body: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
            ),
          ),
          const SizedBox(height: 8),
          TextWithPreview(
            key: ValueKey(_previewKey),
            onChanged: (val) {
              _text = val;
            },
          ),
          NewPostFooter(
            onPostPressed: () async {
              if (_selectedSub == null || _selectedSub?.trim() == '') return;
              if (_titleController.text.trim().isEmpty) return;
              if (_text.trim().isEmpty) return;

              try {
                setState(() {
                  _busy = true;
                });

                final discussion =
                    await locator<SNApiClient>().upsertDiscussion(
                  sub: _selectedSub!.toLowerCase(),
                  title: _titleController.text,
                  text: _text,
                );

                if (discussion == null) {
                  throw Exception('Failed to post discussion');
                }

                setState(() {
                  _titleController.text = '';
                  _text = '';
                  _previewKey = ValueKey(Random().nextDouble());
                });
              } catch (e, st) {
                Utils.showException('Failed to post discussion $e', st);
              } finally {
                setState(() {
                  _busy = false;
                });
              }
            },
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
                    Text('Posting discussion...'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
