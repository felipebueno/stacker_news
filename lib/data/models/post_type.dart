import 'package:flutter/material.dart';

enum PostType {
  top,
  bitcoin,
  nostr,
  tech,
  meta,
  notifications,
  job;

  String get endpoint {
    if (this == PostType.top) {
      return 'top/posts/day.json?when=day';
    } else if (this == PostType.notifications) {
      return 'notifications.json';
    }

    return '~.json?sub=$name';
  }

  String get name {
    switch (this) {
      case PostType.top:
        return 'top';

      case PostType.bitcoin:
        return 'bitcoin';

      case PostType.nostr:
        return 'nostr';

      case PostType.tech:
        return 'tech';

      case PostType.meta:
        return 'meta';

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

      case PostType.bitcoin:
        return 'Bitcoin';

      case PostType.nostr:
        return 'Nostr';

      case PostType.tech:
        return 'Tech';

      case PostType.meta:
        return 'Meta';

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

      case PostType.bitcoin:
        return Icons.monetization_on;

      case PostType.nostr:
        return Icons.chat_bubble_sharp;

      case PostType.tech:
        return Icons.computer;

      case PostType.meta:
        return Icons.info;

      case PostType.job:
        return Icons.work;

      case PostType.notifications:
        return Icons.notifications;

      default:
        return Icons.new_releases;
    }
  }

  String getGraphQLBody(String cursor) {
    if (this == PostType.top) {
      return '{"operationName":"topItems","variables":{"when":"day","cursor":"$cursor"},"query":"fragment ItemFields on Item {\\n  id\\n  parentId\\n  createdAt\\n  deletedAt\\n  title\\n  url\\n  user {\\n    name\\n    streak\\n    hideCowboyHat\\n    id\\n    __typename\\n  }\\n  fwdUserId\\n  otsHash\\n  position\\n  sats\\n  boost\\n  bounty\\n  bountyPaidTo\\n  path\\n  upvotes\\n  meSats\\n  meDontLike\\n  meBookmark\\n  meSubscription\\n  outlawed\\n  freebie\\n  ncomments\\n  commentSats\\n  lastCommentAt\\n  maxBid\\n  isJob\\n  company\\n  location\\n  remote\\n  subName\\n  pollCost\\n  status\\n  uploadId\\n  mine\\n  __typename\\n}\\n\\nquery topItems(\$sort: String, \$cursor: String, \$when: String) {\\n  topItems(sort: \$sort, cursor: \$cursor, when: \$when) {\\n    cursor\\n    items {\\n      ...ItemFields\\n      __typename\\n    }\\n    pins {\\n      ...ItemFields\\n      __typename\\n    }\\n    __typename\\n  }\\n}\\n"}';
    } else if (this == PostType.notifications) {
      return '{"operationName":"Notifications","variables":{"cursor":"$cursor"},"query":"fragment ItemFields on Item {\\n  id\\n  parentId\\n  createdAt\\n  deletedAt\\n  title\\n  url\\n  user {\\n    name\\n    streak\\n    hideCowboyHat\\n    id\\n    __typename\\n  }\\n  fwdUserId\\n  otsHash\\n  position\\n  sats\\n  boost\\n  bounty\\n  bountyPaidTo\\n  path\\n  upvotes\\n  meSats\\n  meDontLike\\n  meBookmark\\n  meSubscription\\n  outlawed\\n  freebie\\n  ncomments\\n  commentSats\\n  lastCommentAt\\n  maxBid\\n  isJob\\n  company\\n  location\\n  remote\\n  subName\\n  pollCost\\n  status\\n  uploadId\\n  mine\\n  __typename\\n}\\n\\nfragment ItemFullFields on Item {\\n  ...ItemFields\\n  text\\n  fwdUser {\\n    name\\n    streak\\n    hideCowboyHat\\n    id\\n    __typename\\n  }\\n  root {\\n    id\\n    title\\n    bounty\\n    bountyPaidTo\\n    subName\\n    user {\\n      name\\n      streak\\n      hideCowboyHat\\n      id\\n      __typename\\n    }\\n    __typename\\n  }\\n  __typename\\n}\\n\\nfragment InviteFields on Invite {\\n  id\\n  createdAt\\n  invitees {\\n    name\\n    id\\n    __typename\\n  }\\n  gift\\n  limit\\n  revoked\\n  user {\\n    name\\n    streak\\n    hideCowboyHat\\n    id\\n    __typename\\n  }\\n  poor\\n  __typename\\n}\\n\\nquery Notifications(\$cursor: String, \$inc: String) {\\n  notifications(cursor: \$cursor, inc: \$inc) {\\n    cursor\\n    lastChecked\\n    notifications {\\n      __typename\\n      ... on Mention {\\n        sortTime\\n        mention\\n        item {\\n          ...ItemFullFields\\n          text\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on Votification {\\n        sortTime\\n        earnedSats\\n        item {\\n          ...ItemFullFields\\n          text\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on Streak {\\n        id\\n        sortTime\\n        days\\n        __typename\\n      }\\n      ... on Earn {\\n        sortTime\\n        earnedSats\\n        sources {\\n          posts\\n          comments\\n          tips\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on Referral {\\n        sortTime\\n        __typename\\n      }\\n      ... on Reply {\\n        sortTime\\n        item {\\n          ...ItemFullFields\\n          text\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on Invitification {\\n        sortTime\\n        invite {\\n          ...InviteFields\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on JobChanged {\\n        sortTime\\n        item {\\n          ...ItemFields\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on InvoicePaid {\\n        sortTime\\n        earnedSats\\n        invoice {\\n          id\\n          __typename\\n        }\\n        __typename\\n      }\\n    }\\n    __typename\\n  }\\n}\\n"}';
    }

    return '{"operationName":"items","variables":{"sub":"$name","cursor":"$cursor"},"query":"fragment ItemFields on Item {\\n  id\\n  parentId\\n  createdAt\\n  deletedAt\\n  title\\n  url\\n  user {\\n    name\\n    streak\\n    hideCowboyHat\\n    id\\n    __typename\\n  }\\n  fwdUserId\\n  otsHash\\n  position\\n  sats\\n  boost\\n  bounty\\n  bountyPaidTo\\n  path\\n  upvotes\\n  meSats\\n  meDontLike\\n  meBookmark\\n  meSubscription\\n  outlawed\\n  freebie\\n  ncomments\\n  commentSats\\n  lastCommentAt\\n  maxBid\\n  isJob\\n  company\\n  location\\n  remote\\n  subName\\n  pollCost\\n  status\\n  uploadId\\n  mine\\n  __typename\\n}\\n\\nquery items(\$sub: String, \$sort: String, \$type: String, \$cursor: String, \$name: String, \$within: String) {\\n  items(\\n    sub: \$sub\\n    sort: \$sort\\n    type: \$type\\n    cursor: \$cursor\\n    name: \$name\\n    within: \$within\\n  ) {\\n    cursor\\n    items {\\n      ...ItemFields\\n      __typename\\n    }\\n    pins {\\n      ...ItemFields\\n      __typename\\n    }\\n    __typename\\n  }\\n}\\n"}';
  }
}
