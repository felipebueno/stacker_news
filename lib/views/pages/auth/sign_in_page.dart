import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stacker_news/data/sn_api.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/auth/check_email_page.dart';
import 'package:stacker_news/views/pages/home_page.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';

class SignInPage extends StatelessWidget {
  static const String id = 'sign_in';

  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GenericPageScaffold(
      title: 'Sign In',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: LoginForm(),
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _busy = ValueNotifier<bool>(false);
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'email@example.com',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (_emailController.text.isEmpty) {
                  return;
                }

                _busy.value = true;
                final ret = await locator<Api>()
                    .requestMagicLink(_emailController.text);
                _busy.value = false;

                if (ret &&
                    (Platform.isAndroid || Platform.isIOS) &&
                    context.mounted) {
                  Navigator.pushNamed(context, CheckEmailPage.id);
                }
              },
              child: const Text('Request Magic Link'),
            ),
            if (!Platform.isAndroid && !Platform.isIOS)
              TextField(
                controller: _tokenController,
                decoration: const InputDecoration(
                  labelText: 'Magic Link',
                  hintText: 'https://stacker.news/api/auth/callback/email/...',
                ),
              ),
            if (!Platform.isAndroid && !Platform.isIOS)
              const SizedBox(height: 24),
            if (!Platform.isAndroid && !Platform.isIOS)
              ElevatedButton(
                onPressed: () async {
                  if (_tokenController.text.isEmpty) {
                    return;
                  }

                  try {
                    _busy.value = true;
                    final session =
                        await locator<Api>().login(_tokenController.text);

                    if (session != null) {
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, HomePage.id);
                      } else {
                        Utils.showError(
                          'Error going to home page. Context is not mounted',
                        );
                      }
                    }
                  } catch (e) {
                    Utils.showError('Error logging in: ${e.toString()}');
                  } finally {
                    _busy.value = false;
                  }
                },
                child: const Text('Login'),
              ),
          ],
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _busy,
          builder: (context, busy, child) {
            if (!busy) {
              return const SizedBox.shrink();
            }

            return Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ],
    );
  }
}
