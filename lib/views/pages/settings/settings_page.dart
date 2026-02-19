import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/user.dart';
import 'package:stacker_news/data/sn_api_client.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';
import 'package:stacker_news/views/widgets/theme_switcher.dart';
import 'package:stacker_news/views/pages/debug/debug_page.dart';

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
        future: locator<SNApiClient>().fetchMe(),
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
                const SizedBox(height: 16),
                const ThemeSwitcher(),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, DebugPage.id),
                  child: const Text('View Logs'),
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
