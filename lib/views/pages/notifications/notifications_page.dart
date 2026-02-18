import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/data/models/sub.dart';
import 'package:stacker_news/data/sn_api_client.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';
import 'package:stacker_news/views/widgets/post/post_list.dart';
import 'package:stacker_news/views/widgets/post/post_list_error.dart';

class NotificationsPage extends StatefulWidget {
  static const String id = 'notifications';

  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _api = locator<SNApiClient>();
  final Sub _notificationsSub = const Sub(name: 'notifications');

  @override
  Widget build(BuildContext context) {
    return GenericPageScaffold(
      title: 'Notifications',
      body: FutureBuilder(
        future: _api.fetchInitialPosts('notifications'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final err = snapshot.error.toString();

            return PostListError(err);
          }

          if (snapshot.hasData) {
            final posts = snapshot.data as List<Post>;

            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: posts.isEmpty
                        ? const Center(child: Text('No notifications found'))
                        : PostList(
                            posts,
                            sub: _notificationsSub,
                          ),
                  ),
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
