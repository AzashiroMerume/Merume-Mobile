import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../exceptions.dart';
import '../models/channel_model.dart';

const storage = FlutterSecureStorage();

Future<List<Channel>> fetchRecommendations(int page, {int limit = 10}) async {
  const baseUrl = 'http://localhost:8081/users/recommendations';
  print("Page of Load More function: ${page}");
  final authToken = await storage.read(key: 'authToken');
  final headers = {'Authorization': '$authToken'};

  if (authToken == null) {
    throw AuthenticationException('Unauthorized');
  }

  try {
    final response = await http.get(
      Uri.parse('$baseUrl?page=$page&limit=$limit'),
      headers: headers,
    );

    switch (response.statusCode) {
      case 200:
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final data = responseData['data'] as List<dynamic>;
        final recommendedChannels = data.map((channelData) {
          final channelJson = channelData as Map<String, dynamic>;
          return Channel.fromJson(channelJson);
        }).toList();
        return recommendedChannels;
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
