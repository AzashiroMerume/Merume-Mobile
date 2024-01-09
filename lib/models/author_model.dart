class Author {
  final String id;
  final String nickname;
  final String username;
  final String? pfpLink;
  final bool? isOnline;

  Author({
    required this.id,
    required this.nickname,
    required this.username,
    this.pfpLink,
    this.isOnline,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id']['\$oid'],
      nickname: json['nickname'],
      username: json['username'],
      pfpLink: json['pfp_link'],
      isOnline: json['is_online'],
    );
  }
}
