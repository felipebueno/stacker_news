part of 'nostr_posts_bloc.dart';

abstract class NostrPostsEvent extends Equatable {
  const NostrPostsEvent();
}

class GetNostrPosts extends NostrPostsEvent {
  const GetNostrPosts();

  @override
  List<Object> get props => [];
}

class GetMoreNostrPosts extends NostrPostsEvent {
  const GetMoreNostrPosts();

  @override
  List<Object> get props => [];
}
