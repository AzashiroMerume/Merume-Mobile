import 'package:merume_mobile/models/author_model.dart';

class Channel {
  final String id;
  final Author author;
  final String channelType;
  final String name;
  final int? goal;
  final String channelVisibility;
  final String description;
  final List<String> categories;
  final List<String>? contributors;
  final Followers followers;
  final int currentChallengeDay;
  final String? channelProfilePictureUrl;
  final DateTime createdAt;

  const Channel({
    required this.id,
    required this.author,
    required this.channelType,
    required this.name,
    this.goal,
    required this.channelVisibility,
    required this.description,
    required this.categories,
    this.contributors,
    required this.followers,
    required this.currentChallengeDay,
    this.channelProfilePictureUrl,
    required this.createdAt,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['_id']['\$oid'],
      author: Author.fromJson(json['author']),
      channelType: json['channel_type'],
      name: json['name'],
      goal: json['goal'],
      channelVisibility: json['channel_visibility'],
      description: json['description'],
      categories: List<String>.from(json['categories']),
      contributors: (json['contributors'] != null &&
              json['contributors'] is List)
          ? List<String>.from(
              json['contributors'].map((contributor) => contributor['\$oid']))
          : null,
      followers: Followers.fromJson(json['followers']),
      currentChallengeDay: json['current_challenge_day'],
      channelProfilePictureUrl: json['channel_profile_picture_url'],
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
