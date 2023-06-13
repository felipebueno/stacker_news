part of 'show_posts_bloc.dart';

abstract class ShowPostsState extends Equatable {
  const ShowPostsState();
}

class ShowPostsInitial extends ShowPostsState {
  @override
  List<Object> get props => [];
}

class ShowPostsLoading extends ShowPostsState {
  const ShowPostsLoading();

  @override
  List<Object> get props => [];
}

class ShowPostsLoaded extends ShowPostsState {
  final List<Item> posts;

  const ShowPostsLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

class ShowPostsError extends ShowPostsState {
  final String message;

  const ShowPostsError(this.message);

  @override
  List<Object> get props => [message];
}

class ShowPostsLoadingMore extends ShowPostsState {
  const ShowPostsLoadingMore();

  @override
  List<Object> get props => [];
}
