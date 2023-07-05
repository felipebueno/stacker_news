import 'package:flutter/material.dart';
import 'package:stacker_news/views/pages/auth/sign_in_page.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';

class LoginFailedPage extends StatelessWidget {
  static const String id = 'login_failed';

  const LoginFailedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericPageScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Unable to sign in',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'The sign in link is no longer valid.\nIt may have been used already\nor it may have expired.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, SignInPage.id);
            },
            child: const Text('Login Again'),
          ),
        ],
      ),
    );
  }
}
