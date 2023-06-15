import 'package:flutter/material.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/widgets/generic_page_scaffold.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String id = 'about';

  @override
  Widget build(BuildContext context) {
    return GenericPageScaffold(
      title: 'About',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            child: Text(
              'Source Code',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.blue,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onPressed: () {
              Utils.launchURL('https://github.com/felipebueno/stacker_news/');
            },
          )
        ],
      ),
    );
  }
}
