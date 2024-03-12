import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:merume_mobile/constants/api_config.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merume_mobile/api/components/get_headers_with_access_token_api.dart';

const storage = FlutterSecureStorage();

Stream<List<Channel>> fetchOwnChannels() async* {
  const channelUrl = '${ConfigAPI.wsURL}user/channels/created';

  while (true) {
    try {
      final headers = await getHeadersWithValidAccessToken();

      final channel = IOWebSocketChannel.connect(
        Uri.parse(channelUrl),
        headers: headers,
      );

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
        print("Error in created_channels_api: $e");
      }

      rethrow;
    }
  }
}
