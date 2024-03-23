import 'package:merume_mobile/models/post_model.dart';
import 'package:merume_mobile/constants/enums.dart';

class PostSent {
  final Post post;
  MessageStatus status;

  PostSent({
    required this.post,
    required this.status,
  });
}
