import 'dart:core';

import 'package:intl/intl.dart';
import 'package:stacker_news/data/models/post.dart';

class User {
  final String? id;
  final String? name;
  final int? streak;
  final int? maxStreak;
  final int? sats;
  final int? stacked;
  final int? freePosts;
  final int? freeComments;
  final int? tipDefault;
  final bool? turboTipping;
  final String? fiatCurrency;
  final int? bioId;
  final bool? upvotePopover;
  final bool? tipPopover;
  final bool? noteItemSats;
  final bool? noteEarning;
  final bool? noteAllDescendants;
  final bool? noteMentions;
  final bool? noteDeposits;
  final bool? noteInvites;
  final bool? noteJobIndicator;
  final bool? noteCowboyHat;
  final bool? hideInvoiceDesc;
  final bool? hideFromTopUsers;
  final bool? hideCowboyHat;
  final bool? wildWestMode;
  final bool? greeterMode;
  final String? lastCheckedJobs;
  final String? typename;
  final bool isContributor;

  final Post? bio;
  final int? nItems;
  final int? nComments;
  final int? nBookmarks;
  final int? photoId;
  final int? since;

  User({
    this.id,
    this.name,
    this.streak,
    this.maxStreak,
    this.sats,
    this.stacked,
    this.freePosts,
    this.freeComments,
    this.tipDefault,
    this.turboTipping,
    this.fiatCurrency,
    this.bioId,
    this.upvotePopover,
    this.tipPopover,
    this.noteItemSats,
    this.noteEarning,
    this.noteAllDescendants,
    this.noteMentions,
    this.noteDeposits,
    this.noteInvites,
    this.noteJobIndicator,
    this.noteCowboyHat,
    this.hideInvoiceDesc,
    this.hideFromTopUsers,
    this.hideCowboyHat,
    this.wildWestMode,
    this.greeterMode,
    this.lastCheckedJobs,
    this.typename,
    this.bio,
    this.nItems,
    this.nComments,
    this.nBookmarks,
    this.photoId,
    this.since,
    this.isContributor = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String?,
      name: json['name'] as String?,
      streak: json['optional']?['streak'] as int?,
      maxStreak: json['optional']?['maxStreak'] as int?,
      sats: json['sats'] as int?,
      stacked: json['optional']?['stacked'] as int?,
      freePosts: json['freePosts'] as int?,
      freeComments: json['freeComments'] as int?,
      tipDefault: json['tipDefault'] as int?,
      turboTipping: json['turboTipping'] as bool?,
      fiatCurrency: json['fiatCurrency'] as String?,
      bioId: json['bioId'] as int?,
      upvotePopover: json['upvotePopover'] as bool?,
      tipPopover: json['tipPopover'] as bool?,
      noteItemSats: json['noteItemSats'] as bool?,
      noteEarning: json['noteEarning'] as bool?,
      noteAllDescendants: json['noteAllDescendants'] as bool?,
      noteMentions: json['noteMentions'] as bool?,
      noteDeposits: json['noteDeposits'] as bool?,
      noteInvites: json['noteInvites'] as bool?,
      noteJobIndicator: json['noteJobIndicator'] as bool?,
      noteCowboyHat: json['noteCowboyHat'] as bool?,
      hideInvoiceDesc: json['hideInvoiceDesc'] as bool?,
      hideFromTopUsers: json['hideFromTopUsers'] as bool?,
      hideCowboyHat: json['hideCowboyHat'] as bool?,
      wildWestMode: json['wildWestMode'] as bool?,
      greeterMode: json['greeterMode'] as bool?,
      lastCheckedJobs: json['lastCheckedJobs'] as String?,
      typename: json['__typename'] as String?,
      bio: json['bio'] != null ? Post.fromJson(json['bio']) : null,
      nItems: json['nitems'] as int?,
      nComments: json['ncomments'] as int?,
      nBookmarks: json['nbookmarks'] as int?,
      photoId: json['photoId'] as int?,
      since: json['since'] as int?,
      isContributor: (json['optional']?['isContributor']) == true,
    );
  }

  String get atName => '@$name';

  String get satsStacked {
    // TODO: Proper exception handling
    try {
      final f = NumberFormat('###,###,###,###', 'en_US');

      return f.format(stacked);
    } catch (e) {
      return stacked?.toString() ?? '';
    }
  }
}
