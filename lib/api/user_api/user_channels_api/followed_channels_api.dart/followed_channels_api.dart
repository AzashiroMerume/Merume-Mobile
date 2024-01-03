import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:merume_mobile/other/api_config.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merume_mobile/models/channel_model.dart';

const storage = FlutterSecureStorage();

Stream<List<Channel>> fetchFollowings() async* {
  const channelUrl = '${ConfigAPI.wsURL}user/channels/subscriptions';
  final accessToken = await storage.read(key: 'accessToken');
  final headers = {'access_token': '$accessToken'};

  while (true) {
    try {
      final channel =
          IOWebSocketChannel.connect(Uri.parse(channelUrl), headers: headers);

      // Listen to incoming data from the WebSocket
      await for (var data in channel.stream) {
        final List<dynamic> channelsJson = json.decode(data);
        final channels =
            channelsJson.map((json) => Channel.fromJson(json)).toList();
        yield channels;
      }

      // The WebSocket connection was closed, attempt to reconnect
      await channel.sink.close();
    } catch (e) {
      // Handle any exceptions that occur during the WebSocket connection

      if (kDebugMode) {
        print('WebSocket error: $e');
      }

      // You can implement a delay here before attempting to reconnect
      await Future.delayed(const Duration(seconds: 5));
    }
  }
}
