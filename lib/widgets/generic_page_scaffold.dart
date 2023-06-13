import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stacker_news/data/post_repository.dart';
import 'package:stacker_news/pages/comments/comments_bloc.dart';
import 'package:stacker_news/pages/home.dart';
import 'package:stacker_news/widgets/sn_logo.dart';

class GenericPageScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final String? title;
  final Widget? body;
  final Widget? mainBody;

  const GenericPageScaffold({
    Key? key,
    this.title,
    this.appBar,
    this.body,
    this.mainBody,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ??
          AppBar(
            centerTitle: true,
            title: SNLogo(text: title),
            actions: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () => Navigator.popUntil(
                  context,
                  ModalRoute.withName(Home.id),
                ),
              ),
            ],
          ),
      body: mainBody ??
          BlocProvider(
            create: (context) => ItemBloc(
              ItemInitial(),
              PostRepositoryImpl(),
            ),
            child: body ?? const SizedBox.shrink(),
          ),
    );
  }
}
