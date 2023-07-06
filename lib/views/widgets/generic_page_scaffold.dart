import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/post.dart';
import 'package:stacker_news/data/models/session.dart';
import 'package:stacker_news/utils.dart';
import 'package:stacker_news/views/pages/about/about_page.dart';
import 'package:stacker_news/views/pages/about/check_email_page.dart';
import 'package:stacker_news/views/pages/auth/sign_in_page.dart';
import 'package:stacker_news/views/pages/home_page.dart';
import 'package:stacker_news/views/pages/notifications/notifications_page.dart';
import 'package:stacker_news/views/pages/post/post_page.dart';
import 'package:stacker_news/views/pages/profile/profile_page.dart';
import 'package:stacker_news/views/pages/settings/settings_page.dart';
import 'package:stacker_news/views/widgets/sn_logo.dart';

class GenericPageScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final String? title;
  final Widget? body;
  final Widget? mainBody;
  final Widget? fab;
  final List<Widget>? moreActions;

  const GenericPageScaffold({
    Key? key,
    this.title,
    this.appBar,
    this.body,
    this.mainBody,
    this.fab,
    this.moreActions,
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
            leading: ((route != PostPage.id &&
                        route != ProfilePage.id &&
                        route != CheckEmailPage.id &&
                        route != NotificationsPage.id &&
                        route != SettingsPage.id) ||
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
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    HomePage.id,
                  );
                },
              ),
              ...(moreActions ?? []),
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
            const Divider(),
            const MaybeSignInButton(),
          ],
        ),
      ),
      body: Center(child: mainBody ?? body),
      floatingActionButton: fab,
    );
  }
}

class MaybeSignInButton extends StatefulWidget {
  const MaybeSignInButton({super.key});

  @override
  State<MaybeSignInButton> createState() => _MaybeLoginButtonState();
}

class _MaybeLoginButtonState extends State<MaybeSignInButton> {
  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name;

    return FutureBuilder(
      future: Utils.getSession(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data is Session) {
          final session = snapshot.data as Session;

          return Column(
            children: [
              ListTile(
                selected: route == ProfilePage.id,
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.pushNamed(
                    context,
                    ProfilePage.id,
                    arguments: session.user?.name,
                  );
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
          );
        }

        return ListTile(
          selected: route == SignInPage.id,
          leading: const Icon(Icons.login),
          title: const Text('Login'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, SignInPage.id);
          },
        );
      },
    );
  }
}
