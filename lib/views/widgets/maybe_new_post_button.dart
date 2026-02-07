import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/session.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/new_post/new_post_page.dart';

class MaybeNewPostFab extends StatefulWidget {
  const MaybeNewPostFab({super.key});

  @override
  State<MaybeNewPostFab> createState() => _MaybeNewPostFabState();
}

class _MaybeNewPostFabState extends State<MaybeNewPostFab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Utils.getSession(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data is Session) {
          return FloatingActionButton.small(
            onPressed: () {
              Navigator.pushNamed(context, NewPostPage.id);
            },
            child: const Icon(Icons.add),
          );
        }

        return Container();
      },
    );
  }
}
