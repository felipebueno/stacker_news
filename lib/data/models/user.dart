import 'dart:core';

class User {
  final String? id;
  final String? name;
  final int? streak;
  final bool? hideCowboyHat;

  User({
    this.id,
    this.name,
    this.streak,
    this.hideCowboyHat,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String?,
      name: json['name'] as String?,
      streak: json['streak'] as int?,
      hideCowboyHat: json['hideCowboyHat'] as bool?,
    );
  }
}
