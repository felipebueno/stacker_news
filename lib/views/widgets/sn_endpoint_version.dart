import 'package:flutter/material.dart';
import 'package:stacker_news/data/shared_prefs_manager.dart';

class SNEndpointVersion extends StatelessWidget {
  const SNEndpointVersion({super.key});

  Future<String> _getVersion() async =>
      await SharedPrefsManager.read('build-id') ?? 'Unknown';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getVersion(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (!snapshot.hasData) return const Text('Loading...');

        return Text(
          'running ${snapshot.data}',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
        );
      },
    );
  }
}
