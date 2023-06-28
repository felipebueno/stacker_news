import 'dart:core';

import 'package:stacker_news/data/models/post.dart';

class User {
  final String? id;
  final String? name;
  final int? streak;
  final bool? hideCowboyHat;
  final Post? bio;
  final int? nItems;
  final int? nComments;
  final int? nBookmarks;
  final int? photoId;
  final int? stacked;
  final int? since;

  User({
    this.id,
    this.name,
    this.streak,
    this.hideCowboyHat,
    this.bio,
    this.nItems,
    this.nComments,
    this.nBookmarks,
    this.photoId,
    this.stacked,
    this.since,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String?,
      name: json['name'] as String?,
      streak: json['streak'] as int?,
      hideCowboyHat: json['hideCowboyHat'] as bool?,
      bio: json['bio'] != null ? Post.fromJson(json['bio']) : null,
      nItems: json['nitems'] as int?,
      nComments: json['ncomments'] as int?,
      nBookmarks: json['nbookmarks'] as int?,
      photoId: json['photoId'] as int?,
      stacked: json['stacked'] as int?,
      since: json['since'] as int?,
    );
  }

  String get atName => '@$name';
}
