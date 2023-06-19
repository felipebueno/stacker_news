part of 'nostr_posts_bloc.dart';

abstract class NostrPostsState extends Equatable {
  const NostrPostsState();
}

class NostrPostsInitial extends NostrPostsState {
  @override
  List<Object> get props => [];
}

class NostrPostsLoading extends NostrPostsState {
  const NostrPostsLoading();

  @override
  List<Object> get props => [];
}

class NostrPostsLoaded extends NostrPostsState {
  final List<Item> posts;

  const NostrPostsLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

class NostrPostsError extends NostrPostsState {
  final String message;

  const NostrPostsError(this.message);

  @override
  List<Object> get props => [message];
}

class NostrPostsLoadingMore extends NostrPostsState {
  const NostrPostsLoadingMore();

  @override
  List<Object> get props => [];
}
