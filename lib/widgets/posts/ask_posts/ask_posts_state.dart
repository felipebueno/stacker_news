part of 'ask_posts_bloc.dart';

abstract class AskPostsState extends Equatable {
  const AskPostsState();
}

class AskPostsInitial extends AskPostsState {
  @override
  List<Object> get props => [];
}

class AskPostsLoading extends AskPostsState {
  const AskPostsLoading();

  @override
  List<Object> get props => [];
}

class AskPostsLoaded extends AskPostsState {
  final List<Item> posts;

  const AskPostsLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

class AskPostsError extends AskPostsState {
  final String message;

  const AskPostsError(this.message);

  @override
  List<Object> get props => [message];
}

class AskPostsLoadingMore extends AskPostsState {
  const AskPostsLoadingMore();

  @override
  List<Object> get props => [];
}
