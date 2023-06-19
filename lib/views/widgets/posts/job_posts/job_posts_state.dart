part of 'job_posts_bloc.dart';

abstract class JobPostsState extends Equatable {
  const JobPostsState();
}

class JobPostsInitial extends JobPostsState {
  @override
  List<Object> get props => [];
}

class JobPostsLoading extends JobPostsState {
  const JobPostsLoading();

  @override
  List<Object> get props => [];
}

class JobPostsLoaded extends JobPostsState {
  final List<Item> posts;

  const JobPostsLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

class JobPostsError extends JobPostsState {
  final String message;

  const JobPostsError(this.message);

  @override
  List<Object> get props => [message];
}

class JobPostsLoadingMore extends JobPostsState {
  const JobPostsLoadingMore();

  @override
  List<Object> get props => [];
}
