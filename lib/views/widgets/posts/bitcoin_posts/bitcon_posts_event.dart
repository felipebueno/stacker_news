part of 'bitcon_posts_bloc.dart';

abstract class BitcoinPostsEvent extends Equatable {
  const BitcoinPostsEvent();
}

class GetBitcoinPosts extends BitcoinPostsEvent {
  const GetBitcoinPosts();

  @override
  List<Object> get props => [];
}

class GetMoreBitcoinPosts extends BitcoinPostsEvent {
  const GetMoreBitcoinPosts();

  @override
  List<Object> get props => [];
}
