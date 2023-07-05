import 'package:timeago/timeago.dart' as ta;

import 'user.dart';

final class Post {
  final String? id;
  final int? parentId;
  final String? createdAt;
  final String? deletedAt;
  final String? title;
  final String? url;
  final int? fwdUserId;
  final String? otsHash;
  final String? position;
  final int? sats;
  final int? boost;
  final int? bounty;
  final List<dynamic>? bountyPaidTo;
  final String? path;
  final int? upvotes;
  final int? meSats;
  final bool? meDontLike;
  final bool? meBookmark;
  final bool? meSubscription;
  final bool? outlawed;
  final bool? freebie;
  final int? ncomments;
  final int? commentSats;
  final String? lastCommentAt;
  final int? maxBid;
  final bool? isJob;
  final String? company;
  final String? location;
  final bool? remote;
  final String? subName;
  final int? pollCost;
  final String? status;
  final int? uploadId;
  final bool? mine;
  final User? user;
  final String? text;
  final List<Post>? comments;
  final String? pageTitle;

  Post({
    this.id,
    this.parentId,
    this.createdAt,
    this.deletedAt,
    this.title,
    this.url,
    this.fwdUserId,
    this.otsHash,
    this.position,
    this.sats,
    this.boost,
    this.bounty,
    this.bountyPaidTo,
    this.path,
    this.upvotes,
    this.meSats,
    this.meDontLike,
    this.meBookmark,
    this.meSubscription,
    this.outlawed,
    this.freebie,
    this.ncomments,
    this.commentSats,
    this.lastCommentAt,
    this.maxBid,
    this.isJob,
    this.company,
    this.location,
    this.remote,
    this.subName,
    this.pollCost,
    this.status,
    this.uploadId,
    this.mine,
    this.user,
    this.text,
    this.comments,
    this.pageTitle,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      parentId: json['parentId'],
      createdAt: json['createdAt'],
      deletedAt: json['deletedAt'],
      title: json['title'],
      url: json['url'],
      fwdUserId: json['fwdUserId'],
      otsHash: json['otsHash'],
      position: json['position'],
      sats: json['sats'],
      boost: json['boost'],
      bounty: json['bounty'],
      bountyPaidTo: json['bountyPaidTo'],
      path: json['path'],
      upvotes: json['upvotes'],
      meSats: json['meSats'],
      meDontLike: json['meDontLike'],
      meBookmark: json['meBookmark'],
      meSubscription: json['meSubscription'],
      outlawed: json['outlawed'],
      freebie: json['freebie'],
      ncomments: json['ncomments'],
      commentSats: json['commentSats'],
      lastCommentAt: json['lastCommentAt'],
      maxBid: json['maxBid'],
      isJob: json['isJob'],
      company: json['company'],
      location: json['location'],
      remote: json['remote'],
      subName: json['subName'],
      pollCost: json['pollCost'],
      status: json['status'],
      uploadId: json['uploadId'],
      mine: json['mine'],
      user: json['user'] == null ? null : User.fromJson(json['user']),
      text: json['text'],
      comments: json['comments'] != null
          ? (json['comments'] as List).map((i) => Post.fromJson(i)).toList()
          : null,
      pageTitle: json['pageTitle'],
    );
  }

  // TODO: Protect against null or invalid createAt
  String get timeAgo =>
      createdAt == null ? '' : ta.format(DateTime.parse(createdAt!));
}
