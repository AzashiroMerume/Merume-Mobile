import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:merume_mobile/other/api_config.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

Stream<List<Channel>> fetchOwnChannels() async* {
  const channelUrl = '${ConfigAPI.wsURL}user/channels/created';
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

      await channel.sink.close();
    } catch (e) {
      if (kDebugMode) {
        print('WebSocket error: $e');
      }

      await Future.delayed(const Duration(seconds: 5));
    }
  }
}
