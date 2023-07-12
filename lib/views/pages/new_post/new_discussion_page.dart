import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/new_post/new_post_footer.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';

class NewDiscussionPage extends StatefulWidget {
  static const String id = 'new_discussion';

  const NewDiscussionPage({super.key});

  @override
  State<NewDiscussionPage> createState() => _NewDiscussionPageState();
}

class _NewDiscussionPageState extends State<NewDiscussionPage> {
  String? _selectedSub;
  int _selectedTab = 0;
  final _textController = TextEditingController();

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
  Widget build(BuildContext context) {
    return GenericPageScaffold(
      title: '$_selectedSub Discussion',
      body: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
            ),
          ),
          const SizedBox(height: 8),
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
                labelText: 'Text',
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
            Expanded(
              child: Markdown(data: _textController.text),
            ),
          const NewPostFooter(),
        ],
      ),
    );
  }
}
