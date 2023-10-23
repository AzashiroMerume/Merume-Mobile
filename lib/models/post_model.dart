import 'package:merume_mobile/models/author_model.dart';

class Post {
  final String id;
  final Author author;
  final String channelId;
  final String? body;
  final List<String>? images;
  final int writtenChallengeDay;
  final int likes;
  final int dislikes;
  final bool alreadyChanged;
  final DateTime createdAt;
  final DateTime updatedAt;

  Post({
    required this.id,
    required this.author,
    required this.channelId,
    this.body,
    this.images,
    required this.writtenChallengeDay,
    required this.likes,
    required this.dislikes,
    required this.alreadyChanged,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id']['\$oid'],
      author: Author.fromJson(json['author']),
      channelId: json['channel_id']['\$oid'],
      body: json['body'],
      images: (json['images'] != null && json['images'] is List)
          ? List<String>.from(json['images'])
          : null,
      writtenChallengeDay: json['written_challenge_day'],
      likes: json['likes'],
      dislikes: json['dislikes'],
      alreadyChanged: json['already_changed'],
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      updatedAt: DateTime.parse(json['updated_at']).toLocal(),
    );
  }
}
