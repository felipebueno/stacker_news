import 'package:flutter/material.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';

class NotificationsPage extends StatelessWidget {
  static const String id = 'notifications';

  const NotificationsPage({super.key});

  Future<String> _getNotifications() async {
    await Future.delayed(const Duration(seconds: 2));

    return 'Notifications';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getNotifications(),
      builder: (context, snaptshot) {
        return GenericPageScaffold(
          title: 'Notifications',
          body: Builder(
            builder: (context) {
              if (snaptshot.hasData) {
                return Center(
                  child: Text(snaptshot.data as String),
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        );
      },
    );
  }
}
