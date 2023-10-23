class Author {
  final String id;
  final String nickname;

  Author({
    required this.id,
    required this.nickname,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id']['\$oid'],
      nickname: json['nickname'],
    );
  }
}
