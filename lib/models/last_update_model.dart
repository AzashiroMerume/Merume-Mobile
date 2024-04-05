import 'package:merume_mobile/constants/enums.dart';
import 'package:merume_mobile/models/post_model.dart';

class LastUpdate {
  final OperationTypes operationType;
  final Post? post;
  final String? postId;

  LastUpdate({
    required this.operationType,
    this.post,
    this.postId,
  });

  factory LastUpdate.fromJson(Map<String, dynamic> json) {
    return LastUpdate(
      operationType: operationTypeFromString(json['operation_type']),
      post: json['post'] != null ? Post.fromJson(json['post']) : null,
      postId: json['post_id'] != null ? json['post_id']['\$oid'] : null,
    );
  }

  static operationTypeFromString(String type) {
    switch (type.toLowerCase()) {
      case 'insert':
        return OperationTypes.insert;
      case 'update':
        return OperationTypes.update;
      case 'delete':
        return OperationTypes.delete;
    }
  }
}
