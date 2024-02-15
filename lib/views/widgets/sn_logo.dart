import 'package:flutter/material.dart';
import 'package:stacker_news/colors.dart';
import 'package:stacker_news/views/widgets/app_version.dart';

import 'sn_endpoint_version.dart';

class SNLogo extends StatelessWidget {
  const SNLogo({
    double? size,
    double? blurRadius,
    String? text,
    String? heroTag,
    bool showEndpointVersion = false,
    bool hideShadow = false,
    bool full = false,
    Color? color,
    super.key,
  })  : _size = size,
        _blurRadius = blurRadius,
        _text = text,
        _heroTag = heroTag,
        _showEndpointVersion = showEndpointVersion,
        _hideShadow = hideShadow,
        _full = full,
        _color = color;

  final double? _size;
  final double? _blurRadius;
  final String? _text;
  final String? _heroTag;
  final bool _showEndpointVersion;
  final bool _hideShadow;
  final bool _full;
  final Color? _color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _full
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LogoText('Stacker News'),
                      AppVersion(),
                    ],
                  )
                : Hero(
                    tag: _heroTag ?? 'sn_logo',
                    child: Material(
                      color: Colors.transparent,
                      child: LogoText(
                        'SN',
                        size: _size,
                        blurRadius: _blurRadius,
                        hideShadow: _hideShadow,
                        color: _color,
                      ),
                    ),
                  ),
            if (_text != null && _text.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(_text),
            ],
          ],
        ),
        if (_showEndpointVersion) ...[
          const SizedBox(width: 8),
          const SNEndpointVersion(),
        ],
      ],
    );
  }
}

class LogoText extends StatelessWidget {
  const LogoText(
    String logoText, {
    double? size,
    double? blurRadius,
    bool hideShadow = false,
    Color? color,
    super.key,
  })  : _logoText = logoText,
        _size = size,
        _blurRadius = blurRadius,
        _hideShadow = hideShadow,
        _color = color;

  final String _logoText;
  final double? _size;
  final double? _blurRadius;
  final bool _hideShadow;
  final Color? _color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Text(
        _logoText,
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
    );
  }
}
