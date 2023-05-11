import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/channel_model.dart';

const storage = FlutterSecureStorage();

Stream<List<Channel>> fetchSubscriptions() async* {
  const channelUrl = 'ws://localhost:8081/users/channels/subscriptions';
  final authToken = await storage.read(key: 'authToken');
  final headers = {'Authorization': '$authToken'};
  final channel =
      IOWebSocketChannel.connect(Uri.parse(channelUrl), headers: headers);

  // Listen to incoming data from the WebSocket
  await for (var data in channel.stream) {
    final List<dynamic> channelsJson = json.decode(data);
    final channels =
        channelsJson.map((json) => Channel.fromJson(json)).toList();
    yield channels;
  }
}

Stream<List<Channel>> fetchOwnChannels() async* {
  const channelUrl = 'ws://localhost:8081/users/channels/created';
  final authToken = await storage.read(key: 'authToken');
  final headers = {'Authorization': '$authToken'};
  final channel =
      IOWebSocketChannel.connect(Uri.parse(channelUrl), headers: headers);

  try {
    // Listen to incoming data from the WebSocket
    await for (var data in channel.stream) {
      final List<dynamic> channelsJson = json.decode(data);
      final channels =
          channelsJson.map((json) => Channel.fromJson(json)).toList();
      yield channels;
    }
    //TODO(): IMPROVE FUCKING EXCEPTION HANDLING HERE
    // } on HttpException catch (e) {
    //   throw NetworkException('HTTP error: ${e.message}');
    // } on WebSocketChannelException catch (e) {
    //   throw NetworkException('WebSocket channel error: ${e.message}');
    // } on SocketException catch (e) {
    //   throw NetworkException('Socket error: ${e.message}');
    // } on FormatException {
    //   throw const FormatException(
    //       'Received invalid JSON data from the WebSocket');
    // } on Exception catch (e) {
    //   throw NetworkException('Unexpected error: ${e.toString()}');
  } finally {
    await channel.sink.close();
  }
}
