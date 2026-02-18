class Sub {
  final String? id;
  final String name;
  final String? desc;
  final bool? nsfw;
  final bool? meMuteSub;

  const Sub({
    this.id,
    required this.name,
    this.desc,
    this.nsfw,
    this.meMuteSub = false,
  });

  factory Sub.fromJson(Map<String, dynamic> json) {
    return Sub(
      id: json['id'],
      name: json['name'] ?? '',
      desc: json['desc'],
      nsfw: json['nsfw'] as bool?,
      meMuteSub: json['meMuteSub'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'desc': desc,
    'nsfw': nsfw,
    'meMuteSub': meMuteSub,
  };
}
