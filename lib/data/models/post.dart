import 'package:timeago/timeago.dart' as ta;

import 'user.dart';

final class Post {
  final String? typeName;
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
    this.typeName,
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
      typeName: json['__typename'],
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

  @override
  String toString() {
    return '$typeName Notification Item\n\nNot Implemented Yet';
  }

  // copyWith
  Post copyWith({
    String? typeName,
    String? id,
    int? parentId,
    String? createdAt,
    String? deletedAt,
    String? title,
    String? url,
    int? fwdUserId,
    String? otsHash,
    String? position,
    int? sats,
    int? boost,
    int? bounty,
    List<dynamic>? bountyPaidTo,
    String? path,
    int? upvotes,
    int? meSats,
    bool? meDontLike,
    bool? meBookmark,
    bool? meSubscription,
    bool? outlawed,
    bool? freebie,
    int? ncomments,
    int? commentSats,
    String? lastCommentAt,
    int? maxBid,
    bool? isJob,
    String? company,
    String? location,
    bool? remote,
    String? subName,
    int? pollCost,
    String? status,
    int? uploadId,
    bool? mine,
    User? user,
    String? text,
    List<Post>? comments,
    String? pageTitle,
  }) {
    return Post(
      typeName: typeName ?? this.typeName,
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      title: title ?? this.title,
      url: url ?? this.url,
      fwdUserId: fwdUserId ?? this.fwdUserId,
      otsHash: otsHash ?? this.otsHash,
      position: position ?? this.position,
      sats: sats ?? this.sats,
      boost: boost ?? this.boost,
      bounty: bounty ?? this.bounty,
      bountyPaidTo: bountyPaidTo ?? this.bountyPaidTo,
      path: path ?? this.path,
      upvotes: upvotes ?? this.upvotes,
      meSats: meSats ?? this.meSats,
      meDontLike: meDontLike ?? this.meDontLike,
      meBookmark: meBookmark ?? this.meBookmark,
      meSubscription: meSubscription ?? this.meSubscription,
      outlawed: outlawed ?? this.outlawed,
      freebie: freebie ?? this.freebie,
      ncomments: ncomments ?? this.ncomments,
      commentSats: commentSats ?? this.commentSats,
      lastCommentAt: lastCommentAt ?? this.lastCommentAt,
      maxBid: maxBid ?? this.maxBid,
      isJob: isJob ?? this.isJob,
      company: company ?? this.company,
      location: location ?? this.location,
      remote: remote ?? this.remote,
      subName: subName ?? this.subName,
      pollCost: pollCost ?? this.pollCost,
      status: status ?? this.status,
      uploadId: uploadId ?? this.uploadId,
      mine: mine ?? this.mine,
      user: user ?? this.user,
      text: text ?? this.text,
      comments: comments ?? this.comments,
      pageTitle: pageTitle ?? this.pageTitle,
    );
  }
}
