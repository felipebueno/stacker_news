import 'dart:math';

import 'package:flutter/material.dart';

class NewJobFooter extends StatefulWidget {
  const NewJobFooter({super.key});

  @override
  State<NewJobFooter> createState() => _NewJobFooterState();
}

class _NewJobFooterState extends State<NewJobFooter> {
  bool _visible = false;
  final _bidController = TextEditingController();

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
                  const Text('Promote'),
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
                controller: _bidController,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Bid (optional)',
                  suffixText: 'sats/min',
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
                                      '1. The higher your bid the higher your job will rank\n',
                                    ),
                                    const Text(
                                        '2. You can increase, decrease, or remove your bid at anytime\n'),
                                    const Text(
                                      '3. You can edit or stop your job at anytime\n',
                                    ),
                                    const Text(
                                      '4. If you run out of sats, your job will stop being promoted until you fill your wallet again',
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
              if (_bidController.text.isNotEmpty)
                Text(
                    '${Random().nextInt(10000) + 1} sats/mo which is \$${Random().nextInt(1000) + 1}/mo'),
              Text(
                  'This bid puts your job in position: ${Random().nextInt(10) + 1}'),
            ],
          ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Post 1000 sats'),
        ),
      ],
    );
  }
}
