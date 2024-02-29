import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:merume_mobile/api/components/get_headers_with_access_token_api.dart';
import 'package:merume_mobile/utils/api_config.dart';
import 'package:merume_mobile/models/post_model.dart';
import 'package:merume_mobile/utils/exceptions.dart';
import 'package:merume_mobile/screens/main/channel_screens/models/post_sent_model.dart';
import 'package:merume_mobile/screens/main/components/enums.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class WebSocketResponse {
  final bool success;
  final Map<String, List<List<Post>>>? data;
  final String errorMessage;

  WebSocketResponse({
    required this.success,
    required this.data,
    required this.errorMessage,
  });

  factory WebSocketResponse.fromJson(Map<String, dynamic> json) {
    return WebSocketResponse(
      success: json['success'],
      data: (json['data'] as Map<String, dynamic>?)?.map((key, value) {
            return MapEntry(
                key,
                (value as List<dynamic>).map((postList) {
                  return (postList as List<dynamic>).map((postJson) {
                    return Post.fromJson(postJson);
                  }).toList();
                }).toList());
          }) ??
          {},
      errorMessage: json['error_message'] ?? '',
    );
  }
}

Stream<Map<String, List<List<PostSent>>>> fetchChannelPosts(
    String channelId) async* {
  String channelUrl = '${ConfigAPI.wsURL}channels/$channelId/content';

  final controller = StreamController<Map<String, List<List<PostSent>>>>();

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
          // Ensure data is not null before adding to the stream
          if (response.data != null) {
            // Transform the received posts to PostSent objects
            final transformedData = response.data!.map((key, value) {
              final List<List<PostSent>> transformedLists =
                  value.map((innerList) {
                return innerList.map((post) {
                  return PostSent(post: post, status: MessageStatus.done);
                }).toList();
              }).toList();
              return MapEntry(key, transformedLists);
            });

            controller.add(transformedData);
          }
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
