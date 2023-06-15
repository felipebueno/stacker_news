import 'package:flutter/material.dart';
import 'package:stacker_news/colors.dart';

import 'sn_version.dart';

class SNLogo extends StatelessWidget {
  const SNLogo({
    double? size,
    double? blurRadius,
    String? text,
    String? heroTag,
    bool? showVersion = false,
    super.key,
  })  : _size = size,
        _blurRadius = blurRadius,
        _text = text,
        _heroTag = heroTag,
        _showVersion = showVersion;

  final double? _size;
  final double? _blurRadius;
  final String? _text;
  final String? _heroTag;
  final bool? _showVersion;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: _heroTag ?? 'sn_logo',
              child: Material(
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
                        blurRadius: _blurRadius ?? _size ?? 32,
                        color: snYellow,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_text != null && _text!.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(_text!),
            ],
          ],
        ),
        if (_showVersion ?? false) ...[
          const SizedBox(width: 8),
          const SNVersion(),
        ],
      ],
    );
  }
}
