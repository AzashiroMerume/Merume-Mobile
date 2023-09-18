import 'dart:async';
import 'dart:convert';

import 'package:merume_mobile/models/channel_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

Stream<List<Channel>> fetchOwnChannels() async* {
  const channelUrl = 'ws://localhost:8081/users/channels/created';
  final authToken = await storage.read(key: 'authToken');
  final headers = {'Authorization': '$authToken'};

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
      print('WebSocket error: $e');
      // You can implement a delay here before attempting to reconnect
      await Future.delayed(const Duration(seconds: 5));
    }
  }
}
