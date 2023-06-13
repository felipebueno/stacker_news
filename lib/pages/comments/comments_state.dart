part of 'comments_bloc.dart';

abstract class ItemState extends Equatable {
  const ItemState();
}

class ItemInitial extends ItemState {
  @override
  List<Object> get props => [];
}

class ItemLoading extends ItemState {
  const ItemLoading();

  @override
  List<Object> get props => [];
}

class ItemLoaded extends ItemState {
  final Item item;

  const ItemLoaded(this.item);

  @override
  List<Object> get props => [item];
}

class ItemError extends ItemState {
  final String message;

  const ItemError(this.message);

  @override
  List<Object> get props => [message];
}
