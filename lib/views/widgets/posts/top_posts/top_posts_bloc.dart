import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:stacker_news/data/models/item.dart';
import 'package:stacker_news/data/sn_api.dart';

part 'top_posts_event.dart';
part 'top_posts_state.dart';

class TopPostsBloc extends Bloc<TopPostsEvent, TopPostsState> {
  List<Item> _posts = [];
  int _from = 21;
  int _to = 42;

  TopPostsBloc(TopPostsState initialState) : super(initialState) {
    on<GetTopPosts>((_, emit) async {
      emit(const TopPostsLoading());

      _from = 21;
      _to = 42;

      try {
        _posts = await Api().fetchPosts(PostType.top);
        emit(TopPostsLoaded(_posts));
      } on NetworkError {
        emit(
          const TopPostsError(
            "Couldn't fetch top posts. Make sure your device is connected to the internet.",
          ),
        );
      } catch (e, st) {
        debugPrintStack(stackTrace: st);
        emit(TopPostsError('${e.toString()}\n$st'));
      }
    });

    on<GetMoreTopPosts>((_, emit) async {
      emit(const TopPostsLoadingMore());

      try {
        final List<Item> newPosts =
            await Api().fetchMorePosts(PostType.top, _from, _to);

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
        emit(TopPostsError('${e.toString()}\n$st'));
      }
    });
  }
}
