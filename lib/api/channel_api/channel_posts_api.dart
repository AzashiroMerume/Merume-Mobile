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

Stream<List<Post>> fetchChannelPosts(String channelId) async* {
  String channelUrl = '${ConfigAPI.wsURL}channels/$channelId/content';

  while (true) {
    try {
      final headers = await getHeadersWithValidAccessToken();

      final channel =
          IOWebSocketChannel.connect(Uri.parse(channelUrl), headers: headers);

      // Listen to incoming data from the WebSocket
      await for (var data in channel.stream) {
        final List<dynamic> postsJson = json.decode(data);
        final posts = postsJson.map((json) => Post.fromJson(json)).toList();
        yield posts;
      }

      await channel.sink.close();
    } catch (e) {
      if (kDebugMode) {
        print('Error in channel_posts_api: $e');
      }

      if (e is TokenExpiredException) {
        throw TokenExpiredException('Token expired');
      }

      await Future.delayed(const Duration(seconds: 5));
    }
  }
}
