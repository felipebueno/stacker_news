import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stacker_news/data/sn_api.dart';
import 'package:stacker_news/main.dart';
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
    return Column(
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

            await locator<Api>().loginWithEmail(_emailController.text);

            // setState(() {
            //   _controller.text =
            //       'bueno.felipe+${Random().nextDouble().toStringAsFixed(6)}@gmail.com';
            // });
          },
          child: const Text('Send Email'),
        ),
        TextField(
          controller: _tokenController,
          decoration: const InputDecoration(
            labelText: 'Auth Link',
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () async {
            if (_tokenController.text.isEmpty) {
              return;
            }

            final ret = await locator<Api>().getSession(_tokenController.text);

            setState(() {
              try {
                _session = ret;
              } catch (e) {
                _session = e.toString();
              }
            });
          },
          child: const Text('Login'),
        ),
        const SizedBox(height: 24),
        Text(_session),
      ],
    );
  }
}
