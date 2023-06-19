import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stacker_news/data/models/item.dart';
import 'package:stacker_news/views/pages/comments/comments_bloc.dart';
import 'package:stacker_news/views/widgets/comment_item.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';
import 'package:stacker_news/views/widgets/post_item.dart';
import 'package:stacker_news/views/widgets/posts/post_utils.dart';

class PostComments extends StatelessWidget {
  static const String id = 'comments';

  const PostComments({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericPageScaffold(
      title: 'Comments',
      body: CommentList(
        item: ModalRoute.of(context)?.settings.arguments as Item,
      ),
    );
  }
}

class CommentList extends StatefulWidget {
  const CommentList({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ItemBloc>(context).add(GetItem(widget.item));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemBloc, ItemState>(
      builder: (context, state) {
        if (state is ItemInitial) {
          return PostListUtils.buildInitialState(context);
        } else if (state is ItemLoading) {
          return PostListUtils.buildLoadingState(context);
        } else if (state is ItemLoaded) {
          final comments = [
            widget.item,
            ...(state.item.comments ?? []),
          ];

          return ListView.separated(
            itemBuilder: (context, index) {
              if (index == 0) {
                return PostItem(state.item, isCommentsPage: true);
              }

              return CommentItem(comments[index]);
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: comments.length,
          );
        } else if (state is ItemError) {
          return PostListUtils.buildInitialState(context);
        }
        return Container();
      },
    );
  }
}
