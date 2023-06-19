import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SNVersion extends StatelessWidget {
  const SNVersion({super.key});

  Future<String> _getVersion() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('build-id') ?? 'Unknown';
  }

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
