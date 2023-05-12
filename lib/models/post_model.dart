class Post {
  final String id;
  final String ownerId;
  final String channelId;
  final String body;
  final String? images;
  final int writtenChallengeDay;
  final int likes;
  final int dislikes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Post({
    required this.id,
    required this.ownerId,
    required this.channelId,
    required this.body,
    this.images,
    required this.writtenChallengeDay,
    required this.likes,
    required this.dislikes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id']['\$oid'],
      ownerId: json['owner_id']['\$oid'],
      channelId: json['channel_id']['\$oid'],
      body: json['body'],
      images: json['images'],
      writtenChallengeDay: json['written_challenge_day'],
      likes: json['likes'],
      dislikes: json['dislikes'],
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      updatedAt: DateTime.parse(json['updated_at']).toLocal(),
    );
  }
}
