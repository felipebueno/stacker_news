import 'package:stacker_news/views/pages/about/about_page.dart';
import 'package:stacker_news/views/pages/auth/check_email_page.dart';
import 'package:stacker_news/views/pages/auth/sign_in_failed_page.dart';
import 'package:stacker_news/views/pages/auth/sign_in_page.dart';
import 'package:stacker_news/views/pages/home_page.dart';
import 'package:stacker_news/views/pages/new_post/new_bounty_page.dart';
import 'package:stacker_news/views/pages/new_post/new_discussion_page.dart';
import 'package:stacker_news/views/pages/new_post/new_job_page.dart';
import 'package:stacker_news/views/pages/new_post/new_link_page.dart';
import 'package:stacker_news/views/pages/new_post/new_poll_page.dart';
import 'package:stacker_news/views/pages/new_post/new_post_page.dart';
import 'package:stacker_news/views/pages/notifications/notifications_page.dart';
import 'package:stacker_news/views/pages/pdf_reader/pdf_reader_page.dart';
import 'package:stacker_news/views/pages/post/post_page.dart';
import 'package:stacker_news/views/pages/profile/profile_page.dart';
import 'package:stacker_news/views/pages/settings/settings_page.dart';

class SNRouter {
  static final routes = {
    HomePage.id: (_) => const HomePage(),
    PostPage.id: (_) => const PostPage(),
    SettingsPage.id: (_) => const SettingsPage(),
    ProfilePage.id: (_) => const ProfilePage(),
    AboutPage.id: (_) => const AboutPage(),
    SignInPage.id: (_) => const SignInPage(),
    CheckEmailPage.id: (_) => const CheckEmailPage(),
    LoginFailedPage.id: (_) => const LoginFailedPage(),
    NotificationsPage.id: (_) => const NotificationsPage(),
    NewPostPage.id: (_) => const NewPostPage(),
    NewLinkPage.id: (_) => const NewLinkPage(),
    NewDiscussionPage.id: (_) => const NewDiscussionPage(),
    NewPollPage.id: (_) => const NewPollPage(),
    NewBountyPage.id: (_) => const NewBountyPage(),
    NewJobPage.id: (_) => const NewJobPage(),
    PdfReaderPage.id: (_) => const PdfReaderPage(),
  };
}
