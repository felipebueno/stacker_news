class Session {
  final SessionUser? user;
  final String? expires;

  Session({
    this.user,
    this.expires,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      user: json['user'] != null ? SessionUser.fromJson(json['user']) : null,
      expires: json['expires'] as String?,
    );
  }

  @override
  String toString() {
    return 'Session{user: $user, expires: $expires}';
  }
}

class SessionUser {
  final int? id;
  final String? name;
  final String? email;
  final String? image;

  SessionUser({
    this.id,
    this.name,
    this.email,
    this.image,
  });

  factory SessionUser.fromJson(Map<String, dynamic> json) {
    return SessionUser(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
    );
  }

  @override
  String toString() {
    return 'SessionUser{id: $id, name: $name, email: $email, image: $image}';
  }
}
