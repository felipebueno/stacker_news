import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacker_news/data/theme_notifier.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) {
        return DropdownButton<String>(
          value: theme.themeModeString,
          hint: const Text('Theme'),
          isExpanded: true,
          onChanged: (String? val) async {
            if (val == null) {
              return;
            }

            theme.setThemeMode(val);
          },
          items: ['System', 'Light', 'Dark']
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
