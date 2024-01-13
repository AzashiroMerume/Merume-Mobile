import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:merume_mobile/api/components/get_headers_with_access_token_api.dart';
import 'package:merume_mobile/other/api_config.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merume_mobile/models/channel_model.dart';

const storage = FlutterSecureStorage();

Stream<List<Channel>> fetchFollowings() async* {
  const channelUrl = '${ConfigAPI.wsURL}user/channels/subscriptions';

  while (true) {
    try {
      final headers = await getHeadersWithValidAccessToken();

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
      if (kDebugMode) {
        print('Error in followed_channels_api: $e');
      }

      rethrow;
    }
  }
}
