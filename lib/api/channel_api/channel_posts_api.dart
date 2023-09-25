import 'dart:async';
import 'dart:convert';

import 'package:merume_mobile/models/post_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

Stream<List<Post>> fetchChannelPosts(String channelId) async* {
  String channelUrl = "ws://localhost:8081/channels/$channelId/content";
  final authToken = await storage.read(key: 'authToken');
  final headers = {'Authorization': '$authToken'};

  while (true) {
    try {
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
      print('WebSocket error: $e');
      await Future.delayed(const Duration(seconds: 5));
    }
  }
}
