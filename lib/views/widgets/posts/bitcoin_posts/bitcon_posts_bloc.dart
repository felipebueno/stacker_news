import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/item.dart';
import 'package:stacker_news/data/sn_api.dart';

part 'bitcon_posts_event.dart';
part 'bitcon_posts_state.dart';

class BitcoinPostsBloc extends Bloc<BitcoinPostsEvent, BitcoinPostsState> {
  final PostRepository postRepository;
  List<Item> posts = [];
  int from = 30;
  int to = 60;

  BitcoinPostsBloc(BitcoinPostsState initialState, this.postRepository)
      : super(initialState) {
    on<GetBitcoinPosts>((event, emit) async {
      emit(const BitcoinPostsLoading());

      from = 30;
      to = 60;

      try {
        posts = await postRepository.fetchPosts(PostType.bitcoin);
        emit(BitcoinPostsLoaded(posts));
      } on NetworkError {
        emit(
          const BitcoinPostsError(
            "Couldn't fetch bitcoin posts. Make sure your device is connected to the internet.",
          ),
        );
      } catch (e, st) {
        debugPrintStack(stackTrace: st);
        emit(BitcoinPostsError('${e.toString()}\n$st'));
      }
    });

    on<GetMoreBitcoinPosts>((event, emit) async {
      emit(const BitcoinPostsLoadingMore());

      try {
        final List<Item> newPosts =
            await postRepository.fetchMorePosts(PostType.bitcoin, from, to);

        final List<Item> morePosts =
            List<Item>.from(BitcoinPostsLoaded(posts).posts)..addAll(newPosts);

        posts = morePosts;

        from += 30;
        to += 30;

        emit(BitcoinPostsLoaded(posts));
      } on NetworkError {
        emit(
          const BitcoinPostsError(
            "Couldn't fetch more bitcoin posts. Make sure your device is connected to the internet.",
          ),
        );
      } catch (e, st) {
        debugPrintStack(stackTrace: st);
        emit(BitcoinPostsError('${e.toString()}\n$st'));
      }
    });
  }
}
