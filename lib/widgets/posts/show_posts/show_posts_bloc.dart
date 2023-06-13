import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:stacker_news/data/models/item.dart';
import 'package:stacker_news/data/post_repository.dart';

part 'show_posts_event.dart';
part 'show_posts_state.dart';

class ShowPostsBloc extends Bloc<ShowPostsEvent, ShowPostsState> {
  final PostRepository postRepository;
  List<Item> posts = [];
  int from = 30;
  int to = 60;

  ShowPostsBloc(ShowPostsState initialState, this.postRepository)
      : super(initialState) {
    on<GetShowPosts>((event, emit) async {
      emit(const ShowPostsLoading());

      from = 30;
      to = 60;

      try {
        posts = await postRepository.fetchPosts(PostType.nostr);
        emit(ShowPostsLoaded(posts));
      } on NetworkError {
        emit(
          const ShowPostsError(
            "Couldn't fetch show posts. Make sure your device is connected to the internet.",
          ),
        );
      } catch (e, st) {
        debugPrintStack(stackTrace: st);
        emit(ShowPostsError(e.toString()));
      }
    });

    on<GetMoreShowPosts>((event, emit) async {
      emit(const ShowPostsLoadingMore());

      try {
        final List<Item> newPosts =
            await postRepository.fetchMorePosts(PostType.nostr, from, to);

        final List<Item> morePosts =
            List<Item>.from(ShowPostsLoaded(posts).posts)..addAll(newPosts);

        posts = morePosts;

        from += 30;
        to += 30;

        emit(ShowPostsLoaded(posts));
      } on NetworkError {
        emit(
          const ShowPostsError(
            "Couldn't fetch more show posts. Make sure your device is connected to the internet.",
          ),
        );
      } catch (e, st) {
        debugPrintStack(stackTrace: st);
        emit(ShowPostsError(e.toString()));
      }
    });
  }
}
