import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/user.dart';
import 'package:stacker_news/data/sn_api.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static const String id = 'settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _zapController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GenericPageScaffold(
      title: 'Settings',
      body: FutureBuilder(
        future: locator<Api>().fetchMe(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading settings'),
            );
          } else if (snapshot.hasData) {
            final me = snapshot.data as User;

            _zapController.text = '${me.tipDefault}';

            return Column(
              children: [
                TextField(
                  controller: _zapController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'zap default',
                    hintText: '100',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Utils.showInfo('Saving settings not implemented yet');
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
