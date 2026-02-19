import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacker_news/colors.dart';
import 'package:stacker_news/data/models/session.dart';
import 'package:stacker_news/data/sn_api_client.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/utils.dart';

class MaybeZapButton extends StatefulWidget {
  final String _id;
  final int? _meSats;
  final void Function(int)? _onZapped;

  const MaybeZapButton(
    String id, {
    int? meSats,
    void Function(int)? onZapped,
    super.key,
  }) : _id = id,
       _meSats = meSats,
       _onZapped = onZapped;

  @override
  State<MaybeZapButton> createState() => _MaybeZapButtonState();
}

class _MaybeZapButtonState extends State<MaybeZapButton> {
  final _busy = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Utils.getSession(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data is Session) {
          return SizedBox(
            width: 32.0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    try {
                      _busy.value = true;
                      final amount = await locator<SNApiClient>().zapPost(widget._id);

                      if (amount == null) return;

                      Utils.showInfo('Zapped $amount sats');

                      widget._onZapped?.call(amount);
                    } catch (e, st) {
                      Utils.showException('Error zapping $e', st);
                    } finally {
                      _busy.value = false;
                    }
                  },
                  icon: SvgPicture.asset(
                    'assets/upvote.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      SNColors.getColor(widget._meSats) ?? Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _busy,
                  builder: (context, busy, child) {
                    if (!busy) {
                      return const SizedBox.shrink();
                    }

                    return const Center(
                      child: SizedBox(
                        width: 12.0,
                        height: 12.0,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }

        return const SizedBox(width: 0);
      },
    );
  }
}
