import 'package:flutter/material.dart';
import 'package:stacker_news/data/sn_api_client.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/views/pages/auth/check_email_page.dart';
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
            child: SignInForm(),
          ),
        ],
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
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
                final ret = await locator<SNApiClient>()
                    .requestMagicLink(_emailController.text);
                _busy.value = false;

                if (ret && context.mounted) {
                  Navigator.pushNamed(context, CheckEmailPage.id);
                }
              },
              child: const Text('Request Magic Link'),
            ),
            const SizedBox(height: 24),
            // const Text('or'),
            // const SizedBox(height: 24),
            // ElevatedButton.icon(
            //   onPressed: () async {
            //     final ret = await BarcodeScanner.scan();

            //     login(ret.rawContent);
            //   },
            //   icon: const Icon(Icons.qr_code),
            //   label: const Text('Read QRCode'),
            // ),
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
