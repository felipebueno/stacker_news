import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseBlocConsumer<TBloc extends Bloc<dynamic, TState>, TState>
    extends StatefulWidget {
  final BlocWidgetListener<TState> listener;
  final BlocWidgetBuilder<TState> builder;
  final void Function()? onReady;

  const BaseBlocConsumer({
    super.key,
    required this.listener,
    required this.builder,
    this.onReady,
  });

  @override
  State<BaseBlocConsumer> createState() =>
      _BaseBlocConsumerState<TBloc, TState>();
}

class _BaseBlocConsumerState<TBloc extends Bloc<dynamic, TState>, TState>
    extends State<BaseBlocConsumer<TBloc, TState>> {
  @override
  void initState() {
    if (widget.onReady != null) {
      widget.onReady!();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TBloc, TState>(
      listener: widget.listener,
      builder: widget.builder,
    );
  }
}
