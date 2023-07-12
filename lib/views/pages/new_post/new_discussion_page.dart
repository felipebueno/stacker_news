import 'package:flutter/material.dart';
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
  String? _selectedSub;

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
      body: const Column(
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
            ),
          ),
          SizedBox(height: 8),
          TextWithPreview(),
          NewPostFooter(),
        ],
      ),
    );
  }
}
