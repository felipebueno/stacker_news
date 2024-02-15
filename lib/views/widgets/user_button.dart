import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/user.dart';
import 'package:stacker_news/views/pages/profile/profile_page.dart';
import 'package:stacker_news/views/widgets/cowboy_streak.dart';

class UserButton extends StatelessWidget {
  final User? user;

  const UserButton(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Text(
          'by: ',
          style: textTheme.bodySmall,
        ),
        InkWell(
          child: Row(
            children: [
              Text(
                '${user?.atName}',
                style: textTheme.titleSmall?.copyWith(color: Colors.blue),
              ),
              const SizedBox(width: 4),
              if (user?.hideCowboyHat != true && user?.streak != null)
                CowboyHat(color: textTheme.titleSmall?.color),
            ],
          ),
          onTap: () {
            if (user == null || user?.name == null) {
              return;
            }

            Navigator.pushNamed(
              context,
              ProfilePage.id,
              arguments: user!.name,
            );
          },
        ),
      ],
    );
  }
}
