import 'package:flutter/material.dart';
import 'package:stacker_news/data/models/user.dart';
import 'package:stacker_news/data/sn_api.dart';
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
    final user = ModalRoute.of(context)?.settings.arguments as String;

    return FutureBuilder(
      future: Api().fetchProfile(user),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const GenericPageScaffold(
            title: 'Loading...',
            body: Center(child: CircularProgressIndicator()),
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
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: BioDetail(user),
          ),
        );
      },
    );
  }
}
