part of 'top_posts_bloc.dart';

abstract class TopPostsEvent extends Equatable {
  const TopPostsEvent();
}

class GetTopPosts extends TopPostsEvent {
  const GetTopPosts();

  @override
  List<Object> get props => [];
}

class GetMoreTopPosts extends TopPostsEvent {
  const GetMoreTopPosts();

  @override
  List<Object> get props => [];
}
