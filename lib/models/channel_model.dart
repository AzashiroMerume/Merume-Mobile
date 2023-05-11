class Channel {
  final String id;
  final String ownerId;
  final String name;
  final String channelType;
  final String description;
  final List<String> categories;
  final Subscriptions subscriptions;
  final int currentChallengeDay;
  final String? baseImage;
  final DateTime createdAt;

  const Channel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.channelType,
    required this.description,
    required this.categories,
    required this.subscriptions,
    required this.currentChallengeDay,
    this.baseImage,
    required this.createdAt,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['_id']['\$oid'],
      ownerId: json['owner_id']['\$oid'],
      name: json['name'],
      channelType: json['channel_type'],
      description: json['description'],
      categories: List<String>.from(json['categories']),
      subscriptions: Subscriptions.fromJson(json['subscriptions']),
      currentChallengeDay: json['current_challenge_day'],
      baseImage: json['base_image'],
      createdAt: DateTime.parse(json['created_at']).toLocal(),
    );
  }
}

class Subscriptions {
  final int currentSubscriptions;
  final List<int> monthlySubscribers;
  final List<int> yearlySubscribers;
  final List<int> twoWeekSubscribers;
  final DateTime lastUpdated;

  const Subscriptions({
    required this.currentSubscriptions,
    required this.monthlySubscribers,
    required this.yearlySubscribers,
    required this.twoWeekSubscribers,
    required this.lastUpdated,
  });

  factory Subscriptions.fromJson(Map<String, dynamic> json) {
    return Subscriptions(
      currentSubscriptions: json['current_subscriptions'],
      monthlySubscribers: List<int>.from(json['monthly_subscribers']),
      yearlySubscribers: List<int>.from(json['yearly_subscribers']),
      twoWeekSubscribers: List<int>.from(json['two_week_subscribers']),
      lastUpdated: DateTime.parse(json['last_updated']).toLocal(),
    );
  }
}