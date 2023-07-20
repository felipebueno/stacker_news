import 'package:flutter/material.dart';
import 'package:stacker_news/data/api.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/data/models/post_type.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';
import 'package:stacker_news/views/widgets/post_list.dart';
import 'package:stacker_news/views/widgets/post_list_error.dart';

class NotificationsPage extends StatefulWidget {
  static const String id = 'notifications';

  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _api = locator<Api>();

  @override
  Widget build(BuildContext context) {
    return GenericPageScaffold(
      title: 'Notifications',
      body: FutureBuilder(
        future: _api.fetchInitialPosts(PostType.notifications),
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
                            postType: PostType.notifications,
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
