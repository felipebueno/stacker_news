import 'package:flutter/material.dart';

class NewPostFooter extends StatefulWidget {
  const NewPostFooter({
    super.key,
    this.onPostPressed,
  });

  final void Function()? onPostPressed;

  @override
  State<NewPostFooter> createState() => _NewPostFooterState();
}

class _NewPostFooterState extends State<NewPostFooter> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _visible = !_visible),
          child: Column(
            children: [
              const Divider(),
              Row(
                children: [
                  Icon(_visible ? Icons.arrow_drop_down : Icons.arrow_right),
                  const Text('Options'),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
        if (_visible)
          Column(
            children: [
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
                            color: Colors.black12.withValues(alpha: .7),
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
            ],
          ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: widget.onPostPressed,
          child: const Text('Post'),
        ),
      ],
    );
  }
}
