import 'package:flutter/material.dart';
import 'package:stacker_news/colors.dart';

class SNLogo extends StatelessWidget {
  const SNLogo({double? size, String? text, super.key})
      : _size = size,
        _text = text;

  final double? _size;
  final String? _text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Hero(
          tag: 'sn_logo',
          child: Text(
            'SN',
            style: TextStyle(
              fontFamily: 'lightning',
              fontWeight: FontWeight.bold,
              fontSize: _size ?? 32,
              color: snYellow,
              shadows: [
                Shadow(
                  offset: const Offset(-2.0, 1.0),
                  blurRadius: _size ?? 32,
                  color: snYellow,
                ),
              ],
            ),
          ),
        ),
        if (_text != null && _text!.isNotEmpty) ...[
          const SizedBox(width: 8),
          Text(_text!),
        ],
      ],
    );
  }
}
