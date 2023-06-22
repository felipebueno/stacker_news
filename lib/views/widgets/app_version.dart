import 'package:flutter/material.dart';
import 'package:stacker_news/utils.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Utils.getAppVersion(),
      builder: (context, snapshot) {
        final style =
            Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10);

        if (snapshot.hasData) {
          return Text(
            'v${snapshot.data}',
            style: style,
          );
        } else if (snapshot.hasError) {
          return Text(
            'Error getting app version : ${snapshot.error}',
            style: style,
          );
        } else {
          return const SizedBox(
            width: 16,
            height: 16,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
