part of 'ask_posts_bloc.dart';

abstract class AskPostsEvent extends Equatable {
  const AskPostsEvent();
}

class GetAskPosts extends AskPostsEvent {
  const GetAskPosts();

  @override
  List<Object> get props => [];
}

class GetMoreAskPosts extends AskPostsEvent {
  const GetMoreAskPosts();

  @override
  List<Object> get props => [];
}
