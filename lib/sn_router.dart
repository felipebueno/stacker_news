import 'package:flutter/material.dart';
import 'package:stacker_news/views/pages/about/about_page.dart';
import 'package:stacker_news/views/pages/home_page.dart';
import 'package:stacker_news/views/pages/post/post_page.dart';
import 'package:stacker_news/views/pages/profile/profile_page.dart';
import 'package:stacker_news/views/pages/settings/settings_page.dart';

class SNRouter {
  static final routes = <String, WidgetBuilder>{
    HomePage.id: (context) => const HomePage(),
    PostPage.id: (context) => const PostPage(),
    SettingsPage.id: (context) => const SettingsPage(),
    ProfilePage.id: (context) => const ProfilePage(),
    AboutPage.id: (context) => const AboutPage(),
  };
}
