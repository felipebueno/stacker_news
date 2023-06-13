import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stacker_news/data/post_repository.dart';
import 'package:stacker_news/pages/comments/comments_bloc.dart';
import 'package:stacker_news/pages/comments/comments_page.dart';
import 'package:stacker_news/pages/home_page.dart';
import 'package:stacker_news/pages/profile/profile_page.dart';
import 'package:stacker_news/pages/settings/settings_page.dart';
import 'package:stacker_news/widgets/sn_logo.dart';

class GenericPageScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final String? title;
  final Widget? body;
  final Widget? mainBody;

  const GenericPageScaffold({
    Key? key,
    this.title,
    this.appBar,
    this.body,
    this.mainBody,
  }) : super(key: key);

  String? _getHeroTag(String? route) {
    switch (route) {
      case ProfilePage.id:
        return 'profile';
      case SettingsPage.id:
        return 'settings';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name;

    return Scaffold(
      appBar: appBar ??
          AppBar(
            centerTitle: true,
            leading: route != PostComments.id
                ? null
                : IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
            title: SNLogo(
              text: title,
              heroTag: _getHeroTag(route),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () => Navigator.popUntil(
                  context,
                  ModalRoute.withName(HomePage.id),
                ),
              ),
            ],
          ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Center(
                child: SNLogo(
                  size: 80,
                  blurRadius: 96,
                  heroTag: 'drawer_logo',
                  showVersion: true,
                ),
              ),
            ),
            ListTile(
              selected: route == HomePage.id,
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, HomePage.id);
              },
            ),
            ListTile(
              selected: route == ProfilePage.id,
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, ProfilePage.id);
              },
            ),
            ListTile(
              selected: route == SettingsPage.id,
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, SettingsPage.id);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: mainBody ??
            BlocProvider(
              create: (context) => ItemBloc(
                ItemInitial(),
                PostRepository(),
              ),
              child: body,
            ),
      ),
    );
  }
}
