import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:stacker_news/data/models/item.dart';
import 'package:stacker_news/data/sn_api.dart';

part 'job_posts_event.dart';
part 'job_posts_state.dart';

class JobPostsBloc extends Bloc<JobPostsEvent, JobPostsState> {
  final PostRepository postRepository;
  List<Item> posts = [];
  int from = 30;
  int to = 60;

  JobPostsBloc(JobPostsState initialState, this.postRepository)
      : super(initialState) {
    on<GetJobPosts>((event, emit) async {
      emit(const JobPostsLoading());

      from = 30;
      to = 60;

      try {
        posts = await postRepository.fetchPosts(PostType.job);
        emit(JobPostsLoaded(posts));
      } on NetworkError {
        emit(
          const JobPostsError(
            "Couldn't fetch posts. Make sure your device is connected to the internet.",
          ),
        );
      } catch (e, st) {
        debugPrintStack(stackTrace: st);
        emit(JobPostsError('${e.toString()}\n$st'));
      }
    });

    on<GetMoreJobPosts>((event, emit) async {
      emit(const JobPostsLoadingMore());

      try {
        final List<Item> newPosts =
            await postRepository.fetchMorePosts(PostType.job, from, to);

        final List<Item> morePosts =
            List<Item>.from(JobPostsLoaded(posts).posts)..addAll(newPosts);

        posts = morePosts;

        from += 30;
        to += 30;

        emit(JobPostsLoaded(posts));
      } on NetworkError {
        emit(
          const JobPostsError(
            "Couldn't fetch more job posts. Make sure your device is connected to the internet.",
          ),
        );
      } catch (e, st) {
        debugPrintStack(stackTrace: st);
        emit(JobPostsError('${e.toString()}\n$st'));
      }
    });
  }
}
