import 'package:flutter/material.dart';
import 'package:stacker_news/views/pages/new_post/new_post_footer.dart';
import 'package:stacker_news/views/pages/new_post/text_with_preview.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';

class NewPollPage extends StatefulWidget {
  static const String id = 'new_poll';

  const NewPollPage({super.key});

  @override
  State<NewPollPage> createState() => _NewPollPageState();
}

class ChoiceController {
  final TextEditingController controller;
  final FocusNode focusNode;

  ChoiceController(this.controller, this.focusNode);
}

class _NewPollPageState extends State<NewPollPage> {
  String? _selectedSub;
  final _choices = [
    ChoiceController(
      TextEditingController(text: ''),
      FocusNode(),
    ),
  ];

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
      title: '$_selectedSub Poll',
      body: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
            ),
          ),
          const SizedBox(height: 8),
          const TextWithPreview(),
          const Divider(),
          const Text('Choices'),
          const Divider(),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Question',
            ),
          ),
          const SizedBox(height: 8),
          if (_choices.isNotEmpty)
            for (int i = 0; i < _choices.length; i++)
              Column(
                children: [
                  const SizedBox(height: 8),
                  TextField(
                    controller: _choices[i].controller,
                    focusNode: _choices[i].focusNode,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Choice ${i + 1}',
                      suffixIcon: _choices.length == 1
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  _choices.removeAt(i);
                                  FocusScope.of(context).unfocus();
                                });
                              },
                              icon: const Icon(Icons.delete),
                            ),
                    ),
                  ),
                ],
              ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _choices.add(ChoiceController(
                  TextEditingController(text: ''),
                  FocusNode(),
                ));
                _choices[_choices.length - 1].focusNode.requestFocus();
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Choice'),
          ),
          const NewPostFooter(),
        ],
      ),
    );
  }
}
