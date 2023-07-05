import 'package:stacker_news/views/pages/about/about_page.dart';
import 'package:stacker_news/views/pages/about/check_email_page.dart';
import 'package:stacker_news/views/pages/about/login_failed_page.dart';
import 'package:stacker_news/views/pages/auth/sign_in_page.dart';
import 'package:stacker_news/views/pages/home_page.dart';
import 'package:stacker_news/views/pages/post/post_page.dart';
import 'package:stacker_news/views/pages/profile/profile_page.dart';
import 'package:stacker_news/views/pages/settings/settings_page.dart';

class SNRouter {
  static final routes = {
    HomePage.id: (context) => const HomePage(),
    PostPage.id: (context) => const PostPage(),
    SettingsPage.id: (context) => const SettingsPage(),
    ProfilePage.id: (context) => const ProfilePage(),
    AboutPage.id: (context) => const AboutPage(),
    SignInPage.id: (context) => const SignInPage(),
    CheckEmailPage.id: (context) => const CheckEmailPage(),
    LoginFailedPage.id: (context) => const LoginFailedPage(),
  };
}
