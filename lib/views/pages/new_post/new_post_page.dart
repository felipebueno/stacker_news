import 'package:flutter/material.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/new_post/new_discussion_page.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';

class NewPostPage extends StatefulWidget {
  static const String id = 'new_post';

  const NewPostPage({super.key});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  String? _selectedSub;

  @override
  Widget build(BuildContext context) {
    return GenericPageScaffold(
      title: 'New Post',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButton<String>(
            value: _selectedSub,
            hint: const Text('pick territory'),
            isExpanded: true,
            onChanged: (String? val) {
              setState(() {
                _selectedSub = val;
              });
            },
            items: ['Bitcoin', 'Nostr', 'Tech', 'Meta', 'Jobs']
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Choose a type of post to create',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const ElevatedButton(
            onPressed: null,
            // onPressed: () {
            //   if (_selectedSub == null || _selectedSub!.isEmpty) {
            //     Utils.showError('Pick a territory first');

            //     return;
            //   }

            //   Navigator.pushNamed(
            //     context,
            //     NewLinkPage.id,
            //     arguments: _selectedSub,
            //   );
            // },
            child: Text('Link'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_selectedSub == null || _selectedSub!.isEmpty) {
                Utils.showError('Pick a territory first');

                return;
              }

              Navigator.pushNamed(
                context,
                NewDiscussionPage.id,
                arguments: _selectedSub,
              );
            },
            child: const Text('Discussion'),
          ),
          const SizedBox(height: 16),
          const ElevatedButton(
            onPressed: null,
            // onPressed: () {
            //   if (_selectedSub == null || _selectedSub!.isEmpty) {
            //     Utils.showError('Pick a territory first');

            //     return;
            //   }

            //   Navigator.pushNamed(
            //     context,
            //     NewPollPage.id,
            //     arguments: _selectedSub,
            //   );
            // },
            child: Text('Poll'),
          ),
          const SizedBox(height: 16),
          const ElevatedButton(
            onPressed: null,
            // onPressed: () {
            //   if (_selectedSub == null || _selectedSub!.isEmpty) {
            //     Utils.showError('Pick a territory first');

            //     return;
            //   }

            //   Navigator.pushNamed(
            //     context,
            //     NewBountyPage.id,
            //     arguments: _selectedSub,
            //   );
            // },
            child: Text('Bounty'),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          const ElevatedButton(
            onPressed: null,
            // onPressed: () {
            //   Navigator.pushNamed(
            //     context,
            //     NewJobPage.id,
            //   );
            // },
            child: Text('Job'),
          ),
        ],
      ),
    );
  }
}
