import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/item.dart';
import 'package:stacker_news/data/post_repository.dart';

part 'ask_posts_event.dart';
part 'ask_posts_state.dart';

class AskPostsBloc extends Bloc<AskPostsEvent, AskPostsState> {
  final PostRepository postRepository;
  List<Item> posts = [];
  int from = 30;
  int to = 60;

  AskPostsBloc(AskPostsState initialState, this.postRepository)
      : super(initialState) {
    on<GetAskPosts>((event, emit) async {
      emit(const AskPostsLoading());

      from = 30;
      to = 60;

      try {
        posts = await postRepository.fetchPosts(PostType.bitcoin);
        emit(AskPostsLoaded(posts));
      } on NetworkError {
        emit(
          const AskPostsError(
            "Couldn't fetch ask posts. Make sure your device is connected to the internet.",
          ),
        );
      } catch (e, st) {
        debugPrintStack(stackTrace: st);
        emit(AskPostsError(e.toString()));
      }
    });

    on<GetMoreAskPosts>((event, emit) async {
      emit(const AskPostsLoadingMore());

      try {
        final List<Item> newPosts =
            await postRepository.fetchMorePosts(PostType.bitcoin, from, to);

        final List<Item> morePosts =
            List<Item>.from(AskPostsLoaded(posts).posts)..addAll(newPosts);

        posts = morePosts;

        from += 30;
        to += 30;

        emit(AskPostsLoaded(posts));
      } on NetworkError {
        emit(
          const AskPostsError(
            "Couldn't fetch more ask posts. Make sure your device is connected to the internet.",
          ),
        );
      } catch (e, st) {
        debugPrintStack(stackTrace: st);
        emit(AskPostsError(e.toString()));
      }
    });
  }
}
