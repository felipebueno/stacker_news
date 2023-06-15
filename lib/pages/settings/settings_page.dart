import 'package:flutter/material.dart';
import 'package:stacker_news/widgets/generic_page_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String id = 'settings';

  @override
  Widget build(BuildContext context) {
    return const GenericPageScaffold(
      title: 'Settings',
      body: Text('Settings Not Implemented Yet'),
    );
  }
}
