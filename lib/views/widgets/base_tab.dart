import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stacker_news/utils.dart';

class BaseTab<TBloc extends Bloc<dynamic, dynamic>> extends StatefulWidget {
  final Widget body;
  final dynamic onRefresh;
  final dynamic onMoreTap;

  const BaseTab({
    Key? key,
    required this.body,
    this.onRefresh,
    this.onMoreTap,
  }) : super(key: key);

  @override
  State<BaseTab> createState() => _BaseTabState<TBloc>();
}

class _BaseTabState<TBloc extends Bloc<dynamic, dynamic>>
    extends State<BaseTab<TBloc>> with AutomaticKeepAliveClientMixin {
  TBloc? _blocProvider;

  Future<void> _onRefresh() async {
    _blocProvider?.add(widget.onRefresh);
  }

  @override
  void initState() {
    super.initState();
    _blocProvider = BlocProvider.of<TBloc>(context);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: widget.body,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('MORE'),
              onPressed: () {
                Utils.showWarning(context, 'Not implemented yet');
              },
            ),
          ),
        ),
      ],
    );
  }
}
