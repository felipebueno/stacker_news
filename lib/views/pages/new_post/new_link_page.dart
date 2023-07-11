import 'package:flutter/material.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';

class NewLinkPage extends StatefulWidget {
  static const String id = 'new_link';

  const NewLinkPage({super.key});

  @override
  State<NewLinkPage> createState() => _NewLinkPageState();
}

class _NewLinkPageState extends State<NewLinkPage> {
  String? _selectedSub;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args = ModalRoute.of(context)!.settings.arguments as String?;
      if (args != null) {
        setState(() {
          _selectedSub = args;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GenericPageScaffold(
      title: '$_selectedSub Link',
      body: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'URL',
            ),
          ),
          const Divider(),
          const Text('Options'),
          const Divider(),
          TextField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Boost',
              suffixText: 'sats',
              suffixIcon: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return Material(
                        color: Colors.black12.withOpacity(.7),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '1. Boost ranks posts higher temporarily based on the amount\n',
                                ),
                                const Text(
                                    '2. The minimum boost is 5000 sats\n'),
                                const Text(
                                  '3. Each 5000 sats of boost is equivalent to one trusted upvote',
                                ),
                                const Text(
                                    '    e.g. 10000 sats is like 2 votes\n'),
                                const Text(
                                  '4. The decay of boost "votes" increases at 2x the rate of organic votes',
                                ),
                                const Text(
                                    '    i.e. boost votes fall out of ranking faster\n'),
                                const Text(
                                  '5. 100% of sats from boost are given back to top stackers as rewards',
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'ok',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontFamily: 'lightning',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.question_mark),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Forward sats to',
              prefix: Text('@'),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}
