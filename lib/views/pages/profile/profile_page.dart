import 'package:flutter/material.dart';
import 'package:stacker_news/data/api.dart';
import 'package:stacker_news/data/models/user.dart';
import 'package:stacker_news/data/shared_prefs_manager.dart';
import 'package:stacker_news/main.dart';
import 'package:stacker_news/views/pages/home_page.dart';
import 'package:stacker_news/views/pages/profile/bio_detail.dart';
import 'package:stacker_news/views/widgets/generic_page_scaffold.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const String id = 'profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userName = ModalRoute.of(context)?.settings.arguments as String;

    return FutureBuilder(
      future: locator<Api>().fetchProfile(userName),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return GenericPageScaffold(
            title: 'Loading...',
            moreActions: [
              TextButton.icon(
                label: const Text('Logout'),
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await SharedPrefsManager.clear();

                  if (context.mounted) {
                    Navigator.pushReplacementNamed(
                      context,
                      HomePage.id,
                    );
                  }
                },
              )
            ],
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const GenericPageScaffold(
            title: 'Error',
            body: Text('Error fetching profile'),
          );
        }

        final user = snapshot.data as User;

        return GenericPageScaffold(
          title: user.name ?? '',
          moreActions: [
            TextButton.icon(
              label: const Text('Logout'),
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await SharedPrefsManager.clear();

                if (context.mounted) {
                  Navigator.pushReplacementNamed(
                    context,
                    HomePage.id,
                  );
                }
              },
            )
          ],
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: BioDetail(
              user,
              onCommentCreated: () {
                setState(() {});
              },
            ),
          ),
        );
      },
    );
  }
}
