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
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final data = responseData['data'] as List<dynamic>;
        final channelPostMap = <Channel, Post>{};
        for (var channelPostData in data) {
          final channelData = channelPostData[0] as Map<String, dynamic>;
          final postJson = channelPostData[1] as Map<String, dynamic>;
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
  } catch (e, stackTrace) {
    print('Exception: $e');
    print('Stack trace:\n$stackTrace');

    if (e is SocketException) {
      throw NetworkException('Network error');
    } else if (e is TimeoutException) {
      throw TimeoutException('Slow internet connection');
    } else if (e is http.ClientException) {
      throw NetworkException('Network error');
    } else {
      rethrow; // Rethrow the caught exception
    }
  }
}
