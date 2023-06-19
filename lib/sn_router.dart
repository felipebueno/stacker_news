import 'package:flutter/material.dart';
import 'package:stacker_news/views/pages/about/about_page.dart';
import 'package:stacker_news/views/pages/comments/comments_page.dart';
import 'package:stacker_news/views/pages/home_page.dart';
import 'package:stacker_news/views/pages/profile/profile_page.dart';
import 'package:stacker_news/views/pages/settings/settings_page.dart';

class SNRouter {
  static final routes = <String, WidgetBuilder>{
    HomePage.id: (context) => const HomePage(),
    PostComments.id: (context) => const PostComments(),
    SettingsPage.id: (context) => const SettingsPage(),
    ProfilePage.id: (context) => const ProfilePage(),
    AboutPage.id: (context) => const AboutPage(),
  };
}
