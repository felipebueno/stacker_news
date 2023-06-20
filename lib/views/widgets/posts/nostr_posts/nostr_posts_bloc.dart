import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:stacker_news/data/models/item.dart';
import 'package:stacker_news/data/sn_api.dart';

part 'nostr_posts_event.dart';
part 'nostr_posts_state.dart';

class NostrPostsBloc extends Bloc<NostrPostsEvent, NostrPostsState> {
  final PostRepository postRepository;
  List<Item> posts = [];
  int from = 30;
  int to = 60;

  NostrPostsBloc(NostrPostsState initialState, this.postRepository)
      : super(initialState) {
    on<GetNostrPosts>((event, emit) async {
      emit(const NostrPostsLoading());

      from = 30;
      to = 60;

      try {
        posts = await postRepository.fetchPosts(PostType.nostr);
        emit(NostrPostsLoaded(posts));
      } on NetworkError {
        emit(
          const NostrPostsError(
            "Couldn't fetch nostr posts. Make sure your device is connected to the internet.",
          ),
        );
      } catch (e, st) {
        debugPrintStack(stackTrace: st);
        emit(NostrPostsError('${e.toString()}\n$st'));
      }
    });

    on<GetMoreNostrPosts>((event, emit) async {
      emit(const NostrPostsLoadingMore());

      try {
        final List<Item> newPosts =
            await postRepository.fetchMorePosts(PostType.nostr, from, to);

        final List<Item> morePosts =
            List<Item>.from(NostrPostsLoaded(posts).posts)..addAll(newPosts);

        posts = morePosts;

        from += 30;
        to += 30;

        emit(NostrPostsLoaded(posts));
      } on NetworkError {
        emit(
          const NostrPostsError(
            "Couldn't fetch more nostr posts. Make sure your device is connected to the internet.",
          ),
        );
      } catch (e, st) {
        debugPrintStack(stackTrace: st);
        emit(NostrPostsError('${e.toString()}\n$st'));
      }
    });
  }
}
