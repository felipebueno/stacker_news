import 'package:flutter/cupertino.dart';
import 'package:stacker_news/widgets/generic_page_scaffold.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const String id = 'profile';

  @override
  Widget build(BuildContext context) {
    return const GenericPageScaffold(
      title: 'Profile',
      body: Text('Profile Not Implemented Yet'),
    );
  }
}
