import 'package:flutter/material.dart';
import 'package:stacker_news/views/pages/new_post/new_post_footer.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';

class NewLinkPage extends StatefulWidget {
  static const String id = 'new_link';

  const NewLinkPage({super.key});

  @override
  State<NewLinkPage> createState() => _NewLinkPageState();
}

class _NewLinkPageState extends State<NewLinkPage> {
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
      title: '$_selectedSub Link',
      body: const Column(
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'URL',
            ),
          ),
          NewPostFooter(),
        ],
      ),
    );
  }
}
