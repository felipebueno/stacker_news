import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stacker_news/data/models/item.dart';
import 'package:stacker_news/data/sn_api.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc(ItemState initialState) : super(initialState) {
    on<GetItem>((event, emit) async {
      emit(const ItemLoading());
      try {
        final item = await Api().fetchItem(event.post);
        emit(ItemLoaded(item));
      } on NetworkError {
        emit(const ItemError(
          "Couldn't fetch comments. Make sure your device is connected to the internet.",
        ));
      }
    });
  }
}
