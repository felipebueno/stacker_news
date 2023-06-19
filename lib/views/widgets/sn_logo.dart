import 'package:flutter/material.dart';
import 'package:stacker_news/colors.dart';

import 'sn_version.dart';

class SNLogo extends StatelessWidget {
  const SNLogo({
    double? size,
    double? blurRadius,
    String? text,
    String? heroTag,
    bool showVersion = false,
    bool hideShadow = false,
    Color? color,
    super.key,
  })  : _size = size,
        _blurRadius = blurRadius,
        _text = text,
        _heroTag = heroTag,
        _showVersion = showVersion,
        _hideShadow = hideShadow,
        _color = color;

  final double? _size;
  final double? _blurRadius;
  final String? _text;
  final String? _heroTag;
  final bool _showVersion;
  final bool _hideShadow;
  final Color? _color;

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
                color: Colors.transparent,
                child: Text(
                  'SN',
                  style: TextStyle(
                    fontFamily: 'lightning',
                    fontWeight: FontWeight.bold,
                    fontSize: _size ?? 32,
                    color: _color ?? snYellow,
                    shadows: _hideShadow
                        ? null
                        : [
                            Shadow(
                              offset: const Offset(-2.0, 1.0),
                              blurRadius: _blurRadius ?? _size ?? 32,
                              color: _color ?? snYellow,
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
        if (_showVersion) ...[
          const SizedBox(width: 8),
          const SNVersion(),
        ],
      ],
    );
  }
}
