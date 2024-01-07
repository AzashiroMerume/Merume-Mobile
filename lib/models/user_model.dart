class User {
  final String id;
  final String nickname;
  final String username;
  final String email;
  final String? pfpLink;
  final List<String>? preferences;

  User({
    required this.id,
    required this.nickname,
    required this.username,
    required this.email,
    this.pfpLink,
    this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']['\$oid'],
      nickname: json['nickname'],
      username: json['username'],
      email: json['email'],
      pfpLink: json['pfp_link'],
      preferences: json['preferences'] != null
          ? List<String>.from(json['preferences'])
          : null,
    );
  }

  User updatePreferences({List<String>? preferences}) {
    return User(
      id: id,
      nickname: nickname,
      username: username,
      email: email,
      pfpLink: pfpLink,
      preferences: preferences ?? this.preferences,
    );
  }
}
