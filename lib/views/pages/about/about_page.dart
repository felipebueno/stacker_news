import 'package:flutter/material.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';
import 'package:stacker_news/views/widgets/sn_logo.dart';
import 'package:stacker_news/views/widgets/stack_button.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String id = 'about';

  @override
  Widget build(BuildContext context) {
    return GenericPageScaffold(
      title: 'About',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SNLogo(
                  showEndpointVersion: true,
                  full: true,
                ),
                const SizedBox(height: 8),
                const Text('by'),
                const StackButton(
                  'felipe',
                  navigateToProfile: true,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.bug_report),
                  label: const Text('Source Code'),
                  onPressed: () {
                    Utils.launchURL('https://github.com/felipebueno/stacker_news/');
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '"The fear of the Lord is the beginning of wisdom, and the knowledge of the Holy One is insight."\n\nProverbs 9:10 (ESV)',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
