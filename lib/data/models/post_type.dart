import 'package:flutter/material.dart';

enum PostType {
  top,
  bitcoin,
  nostr,
  tech,
  meta,
  job;

  String get endpoint {
    if (this == PostType.top) {
      return 'top/posts/day.json?when=day';
    }

    return '~/$name.json?sub=$name';
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

      default:
        return Icons.new_releases;
    }
  }

  String getBody(String cursor) {
    if (this == PostType.top) {
      return '{"operationName":"topItems","variables":{"when":"day","cursor":"$cursor"},"query":"fragment ItemFields on Item {\\n  id\\n  parentId\\n  createdAt\\n  deletedAt\\n  title\\n  url\\n  user {\\n    name\\n    streak\\n    hideCowboyHat\\n    id\\n    __typename\\n  }\\n  fwdUserId\\n  otsHash\\n  position\\n  sats\\n  boost\\n  bounty\\n  bountyPaidTo\\n  path\\n  upvotes\\n  meSats\\n  meDontLike\\n  meBookmark\\n  meSubscription\\n  outlawed\\n  freebie\\n  ncomments\\n  commentSats\\n  lastCommentAt\\n  maxBid\\n  isJob\\n  company\\n  location\\n  remote\\n  subName\\n  pollCost\\n  status\\n  uploadId\\n  mine\\n  __typename\\n}\\n\\nquery topItems(\$sort: String, \$cursor: String, \$when: String) {\\n  topItems(sort: \$sort, cursor: \$cursor, when: \$when) {\\n    cursor\\n    items {\\n      ...ItemFields\\n      __typename\\n    }\\n    pins {\\n      ...ItemFields\\n      __typename\\n    }\\n    __typename\\n  }\\n}\\n"}';
    }

    return '{"operationName":"items","variables":{"sub":"$name","cursor":"$cursor"},"query":"fragment ItemFields on Item {\\n  id\\n  parentId\\n  createdAt\\n  deletedAt\\n  title\\n  url\\n  user {\\n    name\\n    streak\\n    hideCowboyHat\\n    id\\n    __typename\\n  }\\n  fwdUserId\\n  otsHash\\n  position\\n  sats\\n  boost\\n  bounty\\n  bountyPaidTo\\n  path\\n  upvotes\\n  meSats\\n  meDontLike\\n  meBookmark\\n  meSubscription\\n  outlawed\\n  freebie\\n  ncomments\\n  commentSats\\n  lastCommentAt\\n  maxBid\\n  isJob\\n  company\\n  location\\n  remote\\n  subName\\n  pollCost\\n  status\\n  uploadId\\n  mine\\n  __typename\\n}\\n\\nquery items(\$sub: String, \$sort: String, \$type: String, \$cursor: String, \$name: String, \$within: String) {\\n  items(\\n    sub: \$sub\\n    sort: \$sort\\n    type: \$type\\n    cursor: \$cursor\\n    name: \$name\\n    within: \$within\\n  ) {\\n    cursor\\n    items {\\n      ...ItemFields\\n      __typename\\n    }\\n    pins {\\n      ...ItemFields\\n      __typename\\n    }\\n    __typename\\n  }\\n}\\n"}';
  }
}
