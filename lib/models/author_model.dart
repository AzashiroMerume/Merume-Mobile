class Author {
  final String id;
  final String nickname;
  final String username;

  Author({
    required this.id,
    required this.nickname,
    required this.username,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id']['\$oid'],
      nickname: json['nickname'],
      username: json['username'],
    );
  }
}
