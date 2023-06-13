import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:stacker_news/data/models/item.dart';
import 'package:stacker_news/data/post_repository.dart';

part 'top_posts_event.dart';
part 'top_posts_state.dart';

class TopPostsBloc extends Bloc<TopPostsEvent, TopPostsState> {
  final PostRepository postRepository;
  List<Item> _posts = [];
  int _from = 30;
  int _to = 60;

  TopPostsBloc(TopPostsState initialState, this.postRepository)
      : super(initialState) {
    on<GetTopPosts>((event, emit) async {
      emit(const TopPostsLoading());

      _from = 30;
      _to = 60;

      try {
        _posts = await postRepository.fetchPosts(PostType.top);
        emit(TopPostsLoaded(_posts));
      } on NetworkError {
        emit(
          const TopPostsError(
            "Couldn't fetch top posts. Make sure your device is connected to the internet.",
          ),
        );
      } catch (e, st) {
        debugPrintStack(stackTrace: st);
        emit(TopPostsError(e.toString()));
      }
    });

    on<GetMoreTopPosts>((event, emit) async {
      emit(const TopPostsLoadingMore());

      try {
        final List<Item> newPosts =
            await postRepository.fetchMorePosts(PostType.top, _from, _to);

        final List<Item> morePosts =
            List<Item>.from(TopPostsLoaded(_posts).posts)..addAll(newPosts);

        _posts = morePosts;

        _from += 30;
        _to += 30;

        emit(TopPostsLoaded(_posts));
      } on NetworkError {
        emit(
          const TopPostsError(
            "Couldn't fetch more top posts. Make sure your device is connected to the internet.",
          ),
        );
      } catch (e, st) {
        debugPrintStack(stackTrace: st);
        emit(TopPostsError(e.toString()));
      }
    });
  }
}
