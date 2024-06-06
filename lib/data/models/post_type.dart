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
      return '{"operationName":"SubItems","variables":{"includeComments":false,"cursor":"$cursor"},"query":"fragment SubFields on Sub {\\n  name\\n  postTypes\\n  allowFreebies\\n  rankingType\\n  billingType\\n  billingCost\\n  billingAutoRenew\\n  billedLastAt\\n  billPaidUntil\\n  baseCost\\n  userId\\n  desc\\n  status\\n  moderated\\n  moderatedCount\\n  meMuteSub\\n  meSubscription\\n  nsfw\\n  __typename\\n}\\n\\nfragment SubFullFields on Sub {\\n  ...SubFields\\n  user {\\n    name\\n    id\\n    optional {\\n      streak\\n      __typename\\n    }\\n    __typename\\n  }\\n  __typename\\n}\\n\\nfragment ItemFields on Item {\\n  id\\n  parentId\\n  createdAt\\n  deletedAt\\n  title\\n  url\\n  user {\\n    id\\n    name\\n    optional {\\n      streak\\n      __typename\\n    }\\n    meMute\\n    __typename\\n  }\\n  sub {\\n    name\\n    userId\\n    moderated\\n    meMuteSub\\n    meSubscription\\n    nsfw\\n    __typename\\n  }\\n  otsHash\\n  position\\n  sats\\n  boost\\n  bounty\\n  bountyPaidTo\\n  noteId\\n  path\\n  upvotes\\n  meSats\\n  meDontLikeSats\\n  meBookmark\\n  meSubscription\\n  meForward\\n  outlawed\\n  freebie\\n  bio\\n  ncomments\\n  commentSats\\n  lastCommentAt\\n  maxBid\\n  isJob\\n  company\\n  location\\n  remote\\n  subName\\n  pollCost\\n  pollExpiresAt\\n  status\\n  uploadId\\n  mine\\n  imgproxyUrls\\n  rel\\n  __typename\\n}\\n\\nfragment CommentItemExtFields on Item {\\n  text\\n  root {\\n    id\\n    title\\n    bounty\\n    bountyPaidTo\\n    subName\\n    sub {\\n      name\\n      userId\\n      moderated\\n      meMuteSub\\n      __typename\\n    }\\n    user {\\n      name\\n      optional {\\n        streak\\n        __typename\\n      }\\n      id\\n      __typename\\n    }\\n    __typename\\n  }\\n  __typename\\n}\\n\\nquery SubItems(\$sub: String, \$sort: String, \$cursor: String, \$type: String, \$name: String, \$when: String, \$from: String, \$to: String, \$by: String, \$limit: Limit, \$includeComments: Boolean = false) {\\n  sub(name: \$sub) {\\n    ...SubFullFields\\n    __typename\\n  }\\n  items(\\n    sub: \$sub\\n    sort: \$sort\\n    cursor: \$cursor\\n    type: \$type\\n    name: \$name\\n    when: \$when\\n    from: \$from\\n    to: \$to\\n    by: \$by\\n    limit: \$limit\\n  ) {\\n    cursor\\n    items {\\n      ...ItemFields\\n      ...CommentItemExtFields @include(if: \$includeComments)\\n      position\\n      __typename\\n    }\\n    pins {\\n      ...ItemFields\\n      ...CommentItemExtFields @include(if: \$includeComments)\\n      position\\n      __typename\\n    }\\n    __typename\\n  }\\n}"}';
    } else if (this == PostType.notifications) {
      return '{"operationName":"Notifications","variables":{"cursor":"$cursor"},"query":"fragment ItemFields on Item {\\n  id\\n  parentId\\n  createdAt\\n  deletedAt\\n  title\\n  url\\n  user {\\n    id\\n    name\\n    optional {\\n      streak\\n      __typename\\n    }\\n    meMute\\n    __typename\\n  }\\n  sub {\\n    name\\n    userId\\n    moderated\\n    meMuteSub\\n    meSubscription\\n    nsfw\\n    __typename\\n  }\\n  otsHash\\n  position\\n  sats\\n  boost\\n  bounty\\n  bountyPaidTo\\n  noteId\\n  path\\n  upvotes\\n  meSats\\n  meDontLikeSats\\n  meBookmark\\n  meSubscription\\n  meForward\\n  outlawed\\n  freebie\\n  bio\\n  ncomments\\n  commentSats\\n  lastCommentAt\\n  maxBid\\n  isJob\\n  company\\n  location\\n  remote\\n  subName\\n  pollCost\\n  pollExpiresAt\\n  status\\n  uploadId\\n  mine\\n  imgproxyUrls\\n  rel\\n  apiKey\\n  __typename\\n}\\n\\nfragment ItemFullFields on Item {\\n  ...ItemFields\\n  text\\n  root {\\n    id\\n    title\\n    bounty\\n    bountyPaidTo\\n    subName\\n    user {\\n      id\\n      name\\n      optional {\\n        streak\\n        __typename\\n      }\\n      __typename\\n    }\\n    sub {\\n      name\\n      userId\\n      moderated\\n      meMuteSub\\n      meSubscription\\n      __typename\\n    }\\n    __typename\\n  }\\n  forwards {\\n    userId\\n    pct\\n    user {\\n      name\\n      __typename\\n    }\\n    __typename\\n  }\\n  __typename\\n}\\n\\nfragment InviteFields on Invite {\\n  id\\n  createdAt\\n  invitees {\\n    id\\n    name\\n    __typename\\n  }\\n  gift\\n  limit\\n  revoked\\n  user {\\n    id\\n    name\\n    optional {\\n      streak\\n      __typename\\n    }\\n    __typename\\n  }\\n  poor\\n  __typename\\n}\\n\\nfragment SubFields on Sub {\\n  name\\n  createdAt\\n  postTypes\\n  allowFreebies\\n  rankingType\\n  billingType\\n  billingCost\\n  billingAutoRenew\\n  billedLastAt\\n  billPaidUntil\\n  baseCost\\n  userId\\n  desc\\n  status\\n  moderated\\n  moderatedCount\\n  meMuteSub\\n  meSubscription\\n  nsfw\\n  __typename\\n}\\n\\nquery Notifications(\$cursor: String, \$inc: String) {\\n  notifications(cursor: \$cursor, inc: \$inc) {\\n    cursor\\n    lastChecked\\n    notifications {\\n      __typename\\n      ... on Mention {\\n        id\\n        sortTime\\n        mention\\n        item {\\n          ...ItemFullFields\\n          text\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on ItemMention {\\n        id\\n        sortTime\\n        item {\\n          ...ItemFullFields\\n          text\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on Votification {\\n        id\\n        sortTime\\n        earnedSats\\n        item {\\n          ...ItemFullFields\\n          text\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on Revenue {\\n        id\\n        sortTime\\n        earnedSats\\n        subName\\n        __typename\\n      }\\n      ... on ForwardedVotification {\\n        id\\n        sortTime\\n        earnedSats\\n        item {\\n          ...ItemFullFields\\n          text\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on Streak {\\n        id\\n        sortTime\\n        days\\n        __typename\\n      }\\n      ... on Earn {\\n        id\\n        sortTime\\n        minSortTime\\n        earnedSats\\n        sources {\\n          posts\\n          comments\\n          tipPosts\\n          tipComments\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on Referral {\\n        id\\n        sortTime\\n        __typename\\n      }\\n      ... on Reply {\\n        id\\n        sortTime\\n        item {\\n          ...ItemFullFields\\n          text\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on FollowActivity {\\n        id\\n        sortTime\\n        item {\\n          ...ItemFullFields\\n          text\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on TerritoryPost {\\n        id\\n        sortTime\\n        item {\\n          ...ItemFullFields\\n          text\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on TerritoryTransfer {\\n        id\\n        sortTime\\n        sub {\\n          ...SubFields\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on Invitification {\\n        id\\n        sortTime\\n        invite {\\n          ...InviteFields\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on JobChanged {\\n        id\\n        sortTime\\n        item {\\n          ...ItemFields\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on SubStatus {\\n        id\\n        sortTime\\n        sub {\\n          ...SubFields\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on InvoicePaid {\\n        id\\n        sortTime\\n        earnedSats\\n        invoice {\\n          id\\n          nostr\\n          comment\\n          lud18Data\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on WithdrawlPaid {\\n        id\\n        sortTime\\n        earnedSats\\n        withdrawl {\\n          autoWithdraw\\n          __typename\\n        }\\n        __typename\\n      }\\n      ... on Reminder {\\n        id\\n        sortTime\\n        item {\\n          ...ItemFullFields\\n          __typename\\n        }\\n        __typename\\n      }\\n    }\\n    __typename\\n  }\\n}"}';
    }

    return '{"operationName":"SubItems","variables":{"includeComments":false,"sub":"$name","cursor":"$cursor"},"query":"fragment SubFields on Sub {\\n  name\\n  postTypes\\n  allowFreebies\\n  rankingType\\n  billingType\\n  billingCost\\n  billingAutoRenew\\n  billedLastAt\\n  billPaidUntil\\n  baseCost\\n  userId\\n  desc\\n  status\\n  moderated\\n  moderatedCount\\n  meMuteSub\\n  meSubscription\\n  nsfw\\n  __typename\\n}\\n\\nfragment SubFullFields on Sub {\\n  ...SubFields\\n  user {\\n    name\\n    id\\n    optional {\\n      streak\\n      __typename\\n    }\\n    __typename\\n  }\\n  __typename\\n}\\n\\nfragment ItemFields on Item {\\n  id\\n  parentId\\n  createdAt\\n  deletedAt\\n  title\\n  url\\n  user {\\n    id\\n    name\\n    optional {\\n      streak\\n      __typename\\n    }\\n    meMute\\n    __typename\\n  }\\n  sub {\\n    name\\n    userId\\n    moderated\\n    meMuteSub\\n    meSubscription\\n    nsfw\\n    __typename\\n  }\\n  otsHash\\n  position\\n  sats\\n  boost\\n  bounty\\n  bountyPaidTo\\n  noteId\\n  path\\n  upvotes\\n  meSats\\n  meDontLikeSats\\n  meBookmark\\n  meSubscription\\n  meForward\\n  outlawed\\n  freebie\\n  bio\\n  ncomments\\n  commentSats\\n  lastCommentAt\\n  maxBid\\n  isJob\\n  company\\n  location\\n  remote\\n  subName\\n  pollCost\\n  pollExpiresAt\\n  status\\n  uploadId\\n  mine\\n  imgproxyUrls\\n  rel\\n  __typename\\n}\\n\\nfragment CommentItemExtFields on Item {\\n  text\\n  root {\\n    id\\n    title\\n    bounty\\n    bountyPaidTo\\n    subName\\n    sub {\\n      name\\n      userId\\n      moderated\\n      meMuteSub\\n      __typename\\n    }\\n    user {\\n      name\\n      optional {\\n        streak\\n        __typename\\n      }\\n      id\\n      __typename\\n    }\\n    __typename\\n  }\\n  __typename\\n}\\n\\nquery SubItems(\$sub: String, \$sort: String, \$cursor: String, \$type: String, \$name: String, \$when: String, \$from: String, \$to: String, \$by: String, \$limit: Limit, \$includeComments: Boolean = false) {\\n  sub(name: \$sub) {\\n    ...SubFullFields\\n    __typename\\n  }\\n  items(\\n    sub: \$sub\\n    sort: \$sort\\n    cursor: \$cursor\\n    type: \$type\\n    name: \$name\\n    when: \$when\\n    from: \$from\\n    to: \$to\\n    by: \$by\\n    limit: \$limit\\n  ) {\\n    cursor\\n    items {\\n      ...ItemFields\\n      ...CommentItemExtFields @include(if: \$includeComments)\\n      position\\n      __typename\\n    }\\n    pins {\\n      ...ItemFields\\n      ...CommentItemExtFields @include(if: \$includeComments)\\n      position\\n      __typename\\n    }\\n    __typename\\n  }\\n}"}';
  }
}
