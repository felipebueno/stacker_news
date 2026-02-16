import 'package:flutter/material.dart';
import 'package:stacker_news/data/sn_api_client.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/home_page.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';

class CheckEmailPage extends StatefulWidget {
  static const String id = 'check_email';

  const CheckEmailPage({super.key});

  @override
  State<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
  final _busy = ValueNotifier<bool>(false);
  final _tokenController = TextEditingController();
  late final String _email = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['email'];

  @override
  Widget build(BuildContext context) {
    return GenericPageScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Check your email',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A magic code has been sent to your email address ($_email}',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Image.asset('assets/cowboy-saloon.gif'),
          TextField(
            controller: _tokenController,
            decoration: const InputDecoration(
              labelText: 'Type or Paste Magic Code Here',
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              if (_tokenController.text.isEmpty) {
                return;
              }

              try {
                _busy.value = true;
                final session = await locator<SNApiClient>().loginWithMagicCode(
                  email: _email,
                  magicCode: _tokenController.text,
                );

                if (session != null) {
                  if (context.mounted) {
                    await Navigator.pushReplacementNamed(context, HomePage.id);
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
          ValueListenableBuilder<bool>(
            valueListenable: _busy,
            builder: (context, busy, child) {
              if (!busy) {
                return const SizedBox.shrink();
              }

              return Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
