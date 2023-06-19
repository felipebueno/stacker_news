part of 'bitcon_posts_bloc.dart';

abstract class BitcoinPostsState extends Equatable {
  const BitcoinPostsState();
}

class BitcoinPostsInitial extends BitcoinPostsState {
  @override
  List<Object> get props => [];
}

class BitcoinPostsLoading extends BitcoinPostsState {
  const BitcoinPostsLoading();

  @override
  List<Object> get props => [];
}

class BitcoinPostsLoaded extends BitcoinPostsState {
  final List<Item> posts;

  const BitcoinPostsLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

class BitcoinPostsError extends BitcoinPostsState {
  final String message;

  const BitcoinPostsError(this.message);

  @override
  List<Object> get props => [message];
}

class BitcoinPostsLoadingMore extends BitcoinPostsState {
  const BitcoinPostsLoadingMore();

  @override
  List<Object> get props => [];
}
