part of 'comments_bloc.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();
}

class GetItem extends ItemEvent {
  final Item post;

  const GetItem(this.post);

  @override
  List<Object> get props => [post];
}
