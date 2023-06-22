import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stacker_news/colors.dart';
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SNLogo(
            showEndpointVersion: true,
            full: true,
          ),
          TextButton.icon(
            icon: const Icon(Icons.bug_report),
            label: const Text('Source Code'),
            onPressed: () {
              Utils.launchURL('https://github.com/felipebueno/stacker_news/');
            },
          ),
          const SizedBox(height: 32),
          Builder(builder: (context) {
            const addr =
                'lnurl1dp68gurn8ghj7um5v93kketj9ehx2amn9uh8wetvdskkkmn0wahz7mrww4excup0vejkc6tsv5u9ue0w';

            return InkWell(
              onTap: () {
                Utils.launchURL('lightning:$addr');
              },
              splashColor: snYellow,
              child: Card(
                child: QrImageView(
                  data: addr,
                  version: QrVersions.auto,
                  size: 256,
                  backgroundColor: Colors.white,
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          const Text('Tap or scan the QR code to send a tip!'),
          const SizedBox(height: 24),
          const StackButton(
            'felipe',
            navigateToProfile: true,
          ),
        ],
      ),
    );
  }
}
