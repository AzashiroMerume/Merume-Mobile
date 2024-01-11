class Author {
  final String id;
  final String nickname;
  final String username;
  final String? pfpLink;
  final bool? isOnline;
  final DateTime? lastTimeOnline;

  Author({
    required this.id,
    required this.nickname,
    required this.username,
    this.pfpLink,
    this.isOnline,
    this.lastTimeOnline,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id']['\$oid'],
      nickname: json['nickname'],
      username: json['username'],
      pfpLink: json['pfp_link'],
      isOnline: json['is_online'],
      lastTimeOnline: json['is_online'] != null
          ? DateTime.parse(json['last_time_online']).toLocal()
          : null,
    );
  }
}
