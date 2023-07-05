import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacker_news/data/sn_api.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/views/pages/about/check_email_page.dart';
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
  String _session = '';

  @override
  void initState() {
    super.initState();

    _emailController.text =
        'bueno.felipe+${Random().nextDouble().toStringAsFixed(6)}@gmail.com';
  }

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
                // await locator<Api>().requestMagicLink(_emailController.text);
                await Future.delayed(Duration(seconds: 2));

                _busy.value = false;

                // throw Exception('Not implemented');

                if (context.mounted) {
                  Navigator.pushNamed(context, CheckEmailPage.id);
                }
              },
              child: const Text('Request Magic Link'),
            ),
            if (!kDebugMode)
              Column(
                children: [
                  TextField(
                    controller: _tokenController,
                    decoration: const InputDecoration(
                      labelText: 'Auth Link',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_tokenController.text.isEmpty) {
                              return;
                            }

                            try {
                              await locator<Api>()
                                  .validateLink(_tokenController.text);

                              setState(() {
                                _session = 'OK';
                              });
                            } catch (e) {
                              setState(() {
                                _session = e.toString();
                              });
                            }
                          },
                          child: const Text('Validate'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_tokenController.text.isEmpty) {
                              return;
                            }

                            final ret = await locator<Api>()
                                .getSession(_tokenController.text);

                            setState(() {
                              try {
                                _session = ret.toString();
                              } catch (e) {
                                _session = e.toString();
                              }
                            });

                            if (context.mounted) {
                              Navigator.pushNamed(context, HomePage.id);
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(_session),
                ],
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
