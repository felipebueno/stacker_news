import 'package:flutter/material.dart';
import 'package:stacker_news/pages/comments/comments.dart';
import 'package:stacker_news/pages/home.dart';

class HNRouter {
  static Map<String, WidgetBuilder> routes = {
    Home.id: (context) => const Home(),
    PostComments.id: (context) => const PostComments(),
  };
}
