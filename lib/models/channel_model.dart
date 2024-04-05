import 'package:merume_mobile/constants/enums.dart';
import 'package:merume_mobile/models/author_model.dart';

class Channel {
  final String id;
  final Author author;
  final String name;
  final VisibilityTypes visibility;
  final String description;
  final List<String> categories;
  final Challenge challenge;
  final List<String>? contributors;
  final Followers followers;
  final String? channelPfpLink;
  final DateTime createdAt;

  const Channel({
    required this.id,
    required this.author,
    required this.name,
    required this.visibility,
    required this.description,
    required this.categories,
    required this.challenge,
    this.contributors,
    required this.followers,
    this.channelPfpLink,
    required this.createdAt,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['_id']['\$oid'],
      author: Author.fromJson(json['author']),
      name: json['name'],
      visibility: visibilityTypeFromString(json['visibility']),
      description: json['description'],
      categories: List<String>.from(json['categories']),
      challenge: Challenge.fromJson(json['challenge']),
      contributors: (json['contributors'] != null &&
              json['contributors'] is List)
          ? List<String>.from(
              json['contributors'].map((contributor) => contributor['\$oid']))
          : null,
      followers: Followers.fromJson(json['followers']),
      channelPfpLink: json['channel_pfp_link'],
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

class Challenge {
  final ChallengeTypes challengeType;
  final int? goal;
  final int points;
  final int currentDay;
  final int streak;
  final int missedCount;
  final List<DateTime>? missedDays;

  const Challenge({
    required this.challengeType,
    this.goal,
    required this.points,
    required this.currentDay,
    required this.streak,
    required this.missedCount,
    this.missedDays,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      challengeType: challengeTypeFromString(json['challenge_type']),
      goal: json['goal'],
      points: json['points'],
      currentDay: json['current_day'],
      streak: json['streak'],
      missedCount: json['missed_count'],
      missedDays: json['missed_days'] != null
          ? List<DateTime>.from(
              json['missed_days'].map((date) => DateTime.parse(date)))
          : null,
    );
  }
}
