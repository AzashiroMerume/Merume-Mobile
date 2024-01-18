import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:merume_mobile/api/components/get_headers_with_access_token_api.dart';
import 'package:merume_mobile/other/api_config.dart';
import 'package:merume_mobile/models/post_model.dart';
import 'package:merume_mobile/other/exceptions.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class WebSocketResponse {
  final bool success;
  final List<Post> data;
  final String errorMessage;

  WebSocketResponse({
    required this.success,
    required this.data,
    required this.errorMessage,
  });

  factory WebSocketResponse.fromJson(Map<String, dynamic> json) {
    return WebSocketResponse(
      success: json['success'],
      data: (json['data'] as List<dynamic>?)?.map((postJson) {
            return Post.fromJson(postJson);
          }).toList() ??
          [],
      errorMessage: json['error_message'] ?? '',
    );
  }
}

Stream<List<Post>> fetchChannelPosts(String channelId) async* {
  String channelUrl = '${ConfigAPI.wsURL}channels/$channelId/content';

  final controller = StreamController<List<Post>>();

  try {
    final headers = await getHeadersWithValidAccessToken();

    final channel =
        IOWebSocketChannel.connect(Uri.parse(channelUrl), headers: headers);

    channel.stream.listen(
      (data) {
        final dynamic responseJson = json.decode(data);
        final WebSocketResponse response =
            WebSocketResponse.fromJson(responseJson);

        if (response.success) {
          controller.add(response.data);
        } else {
          if (response.errorMessage == 'Unauthorized access') {
            controller
                .addError(UnauthorizedAccessException('Unauthorized access'));
          } else {
            controller.addError(ServerException('Server Error'));
          }
        }
      },
      onDone: () {
        controller.close();
        throw ServerException('Server Error');
      },
      onError: (error) {
        controller.addError(error);
      },
      cancelOnError: true,
    );
  } catch (e) {
    if (kDebugMode) {
      print('Error in channel_posts_api: $e');
    }

    controller.addError(e);
  }

  // Return the broadcast stream from the controller
  yield* controller.stream;
}
