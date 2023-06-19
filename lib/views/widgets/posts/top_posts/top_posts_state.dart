part of 'top_posts_bloc.dart';

abstract class TopPostsState extends Equatable {
  const TopPostsState();
}

class TopPostsInitial extends TopPostsState {
  @override
  List<Object> get props => [];
}

class TopPostsLoading extends TopPostsState {
  const TopPostsLoading();

  @override
  List<Object> get props => [];
}

class TopPostsLoaded extends TopPostsState {
  final List<Item> posts;

  const TopPostsLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

class TopPostsError extends TopPostsState {
  final String message;

  const TopPostsError(this.message);

  @override
  List<Object> get props => [message];
}

class TopPostsLoadingMore extends TopPostsState {
  const TopPostsLoadingMore();

  @override
  List<Object> get props => [];
}
