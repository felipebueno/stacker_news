import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/views/pages/about/about_page.dart';
import 'package:stacker_news/views/pages/home_page.dart';
import 'package:stacker_news/views/pages/post/post_page.dart';
import 'package:stacker_news/views/pages/profile/profile_page.dart';
import 'package:stacker_news/views/pages/settings/settings_page.dart';
import 'package:stacker_news/views/widgets/sn_logo.dart';

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
            leading: ((route != PostPage.id && route != ProfilePage.id) ||
                    title == 'FAQ')
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
                  showEndpointVersion: true,
                  full: true,
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
            // ListTile(
            //   selected: route == ProfilePage.id,
            //   leading: const Icon(Icons.person),
            //   title: const Text('Profile'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.pushNamed(context, ProfilePage.id);
            //   },
            // ),
            // ListTile(
            //   selected: route == SettingsPage.id,
            //   leading: const Icon(Icons.settings),
            //   title: const Text('Settings'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.pushNamed(context, SettingsPage.id);
            //   },
            // ),
            ListTile(
              selected: route == AboutPage.id,
              leading: const Icon(Icons.settings),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AboutPage.id);
              },
            ),
            ListTile(
              selected: route == PostPage.id,
              leading: const Icon(Icons.question_mark),
              title: const Text('FAQ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(
                  PostPage.id,
                  arguments: Post(
                    id: '349',
                    pageTitle: 'FAQ',
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(child: mainBody ?? body),
    );
  }
}
