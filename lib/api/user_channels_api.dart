import 'dart:async';
import 'dart:convert';

// import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

Stream<List<Channel>> fetchChannels() async* {
  final channelUrl = 'ws://localhost:8081/channels';
  final channel = WebSocketChannel.connect(Uri.parse(channelUrl));

  // Listen to incoming data from the WebSocket
  await for (var data in channel.stream) {
    final List<dynamic> channelsJson = json.decode(data);
    final channels =
        channelsJson.map((json) => Channel.fromJson(json)).toList();
    yield channels;
  }
}

class Channel {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String baseImage;

  const Channel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.baseImage,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['_id']['\$oid'] ?? '',
      ownerId: json['owner_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      baseImage: json['base_image'] ?? '',
    );
  }
}
