import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../exceptions.dart';
import '../models/channel_model.dart';
import '../models/post_model.dart';

const storage = FlutterSecureStorage();

Future<Map<Channel, Post>> fetchRecommendations(int page,
    {int limit = 20}) async {
  const channelUrl = 'http://localhost:8081/users/recommendations';
  final authToken = await storage.read(key: 'authToken');
  final headers = {'Authorization': '$authToken'};

  if (authToken == null) {
    throw AuthenticationException('Unauthorized');
  }

  try {
    final response = await http.get(
      Uri.parse(channelUrl),
      headers: headers,
    );

    print("Status code: ${response.statusCode}");

    switch (response.statusCode) {
      case 200:
        final data = jsonDecode(response.body) as List<dynamic>;
        final channelPostMap = <Channel, Post>{};
        for (final channelJson in data) {
          final channelData = channelJson['data'] as Map<String, dynamic>;
          final postJson = channelJson['page'] as Map<String, dynamic>;
          final post = Post.fromJson(postJson);
          final channel = Channel.fromJson(channelData);
          channelPostMap[channel] = post;
        }
        return channelPostMap;
      case 401:
        await storage.delete(key: 'authToken');
        throw AuthenticationException('Unauthorized');
      case 500:
        throw ServerException('Internal server error');
      default:
        throw HttpException('Unexpected status code: ${response.statusCode}');
    }
  } on SocketException {
    throw NetworkException('Network error');
  } on TimeoutException {
    throw NetworkException('Request timeout');
  } on http.ClientException {
    throw NetworkException('HTTP client error');
  } catch (e) {
    throw Exception('Unknown error occurred: $e');
  }
}
