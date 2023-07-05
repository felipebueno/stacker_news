import 'package:flutter/material.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';

class CheckEmailPage extends StatelessWidget {
  static const String id = 'check_email';

  const CheckEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericPageScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Check your email',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'A sign in link has been sent to your email address',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Image.asset('assets/hello.gif'),
        ],
      ),
    );
  }
}
