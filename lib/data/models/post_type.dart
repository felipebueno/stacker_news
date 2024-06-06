import 'package:flutter/material.dart';

enum PostType {
  home,
  recent,
  top,
  bitcoin,
  meta,
  builders,
  opensource,
  nostr,
  tech,
  notifications,
  job;

  String get endpoint {
    if (this == PostType.top) {
      return 'top/posts/day.json?when=day';
    } else if (this == PostType.recent) {
      return 'recent.json';
    } else if (this == PostType.home) {
      return 'index.json';
    } else if (this == PostType.notifications) {
      return 'notifications.json';
    }

    return '~.json?sub=$name';
  }

  String get name {
    switch (this) {
      case PostType.top:
        return 'top';

      case PostType.home:
        return 'index';

      case PostType.recent:
        return 'recent';

      case PostType.bitcoin:
        return 'bitcoin';

      case PostType.nostr:
        return 'nostr';

      case PostType.tech:
        return 'tech';

      case PostType.meta:
        return 'meta';

      case PostType.builders:
        return 'builders';

      case PostType.opensource:
        return 'opensource';

      case PostType.job:
        return 'jobs';

      case PostType.notifications:
        return 'notifications';

      default:
        return '';
    }
  }

  String get title {
    switch (this) {
      case PostType.top:
        return 'Top';

      case PostType.home:
        return 'Home';

      case PostType.recent:
        return 'Recent';

      case PostType.bitcoin:
        return 'Bitcoin';

      case PostType.nostr:
        return 'Nostr';

      case PostType.tech:
        return 'Tech';

      case PostType.meta:
        return 'Meta';

      case PostType.builders:
        return 'Builders';

      case PostType.opensource:
        return 'FOSS';

      case PostType.job:
        return 'Jobs';

      case PostType.notifications:
        return 'Notifications';

      default:
        return '';
    }
  }

  IconData get icon {
    switch (this) {
      case PostType.top:
        return Icons.new_releases;

      case PostType.home:
        return Icons.home;

      case PostType.recent:
        return Icons.bar_chart_rounded;

      case PostType.bitcoin:
        return Icons.monetization_on;

      case PostType.nostr:
        return Icons.chat_bubble_sharp;

      case PostType.tech:
        return Icons.computer;

      case PostType.meta:
        return Icons.info;

      case PostType.builders:
        return Icons.handyman_sharp;

      case PostType.opensource:
        return Icons.code;

      case PostType.job:
        return Icons.work;

      case PostType.notifications:
        return Icons.notifications;

      default:
        return Icons.new_releases;
    }
  }
}
