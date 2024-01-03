import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:merume_mobile/api/auth_api/access_token_api.dart';
import 'package:merume_mobile/other/api_config.dart';
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/other/exceptions.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

Stream<List<Channel>> fetchOwnChannels() async* {
  const channelUrl = '${ConfigAPI.wsURL}user/channels/created';
  final accessToken = await storage.read(key: 'accessToken');
  var headers = {'access_token': '$accessToken'};

  while (true) {
    try {
      final checkAuthResponse = await http.get(
        Uri.parse('${ConfigAPI.baseURL}auth'), // Check the authentication token
        headers: headers,
      );

      if (checkAuthResponse.statusCode == 401) {
        // Handle authentication error (token expired or invalid)
        final errorResponse = json.decode(checkAuthResponse.body);
        if (errorResponse['error_message'] == 'Expired') {
          await storage.delete(key: 'accessToken');
          final newAccessToken = await getNewAccessToken();

          if (newAccessToken != null) {
            headers['access_token'] = newAccessToken;
          } else {
            throw TokenErrorException('Token auth error');
          }
        } else {
          throw TokenErrorException('Token auth error');
        }
      }

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
