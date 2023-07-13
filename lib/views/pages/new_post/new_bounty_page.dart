import 'package:flutter/material.dart';
import 'package:stacker_news/views/pages/new_post/new_post_footer.dart';
import 'package:stacker_news/views/pages/new_post/text_with_preview.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';

class NewBountyPage extends StatefulWidget {
  static const String id = 'new_bounty';

  const NewBountyPage({super.key});

  @override
  State<NewBountyPage> createState() => _NewBountyPageState();
}

class _NewBountyPageState extends State<NewBountyPage> {
  String? _selectedSub;
  final _bountyController = TextEditingController(text: '1000');

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
      title: '$_selectedSub Bounty',
      body: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _bountyController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Bounty',
              suffixText: 'sats',
            ),
          ),
          const TextWithPreview(),
          const SizedBox(height: 8),
          const NewPostFooter(),
        ],
      ),
    );
  }
}
