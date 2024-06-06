import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacker_news/colors.dart';

class CowboyStreak extends StatelessWidget {
  final int? streak;

  const CowboyStreak({this.streak, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: SNColors.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ),
        child: Row(
          children: [
            const CowboyHat(),
            if (streak != null) const SizedBox(width: 4),
            if (streak != null)
              Text(
                '$streak',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.black),
              ),
          ],
        ),
      ),
    );
  }
}

class CowboyHat extends StatelessWidget {
  const CowboyHat({
    this.size,
    this.color,
    super.key,
  });

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/cowboy-hat.svg',
      width: size ?? 16,
      height: size ?? 16,
      colorFilter: ColorFilter.mode(
        color ?? Colors.black,
        BlendMode.srcIn,
      ),
    );
  }
}
