class Channel {
  final String id;
  final String ownerId;
  final String ownerNickname;
  final String name;
  final String channelType;
  final String description;
  final List<String> categories;
  final Followers followers;
  final int currentChallengeDay;
  final String? baseImage;
  final DateTime createdAt;

  const Channel({
    required this.id,
    required this.ownerId,
    required this.ownerNickname,
    required this.name,
    required this.channelType,
    required this.description,
    required this.categories,
    required this.followers,
    required this.currentChallengeDay,
    this.baseImage,
    required this.createdAt,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['_id']['\$oid'],
      ownerId: json['owner_id']['\$oid'],
      ownerNickname: json['owner_nickname'],
      name: json['name'],
      channelType: json['channel_type'],
      description: json['description'],
      categories: List<String>.from(json['categories']),
      followers: Followers.fromJson(json['followers']),
      currentChallengeDay: json['current_challenge_day'],
      baseImage: json['base_image'],
      createdAt: DateTime.parse(json['created_at']).toLocal(),
    );
  }
}

class Followers {
  final int currentFollowing;
  final List<int> monthlyFollowers;
  final List<int> yearlyFollowers;
  final List<int> twoWeekFollowers;
  final DateTime lastUpdated;

  const Followers({
    required this.currentFollowing,
    required this.monthlyFollowers,
    required this.yearlyFollowers,
    required this.twoWeekFollowers,
    required this.lastUpdated,
  });

  factory Followers.fromJson(Map<String, dynamic> json) {
    return Followers(
      currentFollowing: json['current_following'],
      monthlyFollowers: List<int>.from(json['monthly_followers']),
      yearlyFollowers: List<int>.from(json['yearly_followers']),
      twoWeekFollowers: List<int>.from(json['two_week_followers']),
      lastUpdated: DateTime.parse(json['last_updated']).toLocal(),
    );
  }
}
