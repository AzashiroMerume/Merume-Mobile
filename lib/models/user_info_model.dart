class UserInfo {
  final String id;
  final String nickname;
  final String username;
  final String email;
  final List<String>? preferences;

  UserInfo({
    required this.id,
    required this.nickname,
    required this.username,
    required this.email,
    this.preferences,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['user_id']['\$oid'],
      nickname: json['nickname'],
      username: json['username'],
      email: json['email'],
      preferences: json['preferences'] != null
          ? List<String>.from(json['preferences'])
          : null,
    );
  }
}
