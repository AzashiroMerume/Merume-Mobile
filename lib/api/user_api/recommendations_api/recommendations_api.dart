import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merume_mobile/other/api_config.dart';
import '../../../other/exceptions.dart';
import '../../../models/channel_model.dart';

const storage = FlutterSecureStorage();

Future<List<Channel>> fetchRecommendations(int page, {int limit = 10}) async {
  const baseUrl = '${ConfigAPI.baseURL}user/recommendations';
  final accessToken = await storage.read(key: 'accessToken');
  final headers = {'Authorization': '$accessToken'};

  if (accessToken == null) {
    throw AuthenticationException('Unauthorized');
  }

  try {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkException('No internet connection');
    }

    final response = await http.get(
      Uri.parse('$baseUrl?page=$page&limit=$limit'),
      headers: headers,
    );

    if (kDebugMode) {
      print("Status code: ${response.statusCode}");
    }

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
        await storage.delete(key: 'accessToken');
        throw AuthenticationException('Unauthorized');
      case 500:
        throw ServerException('Internal server error');
      default:
        throw HttpException('Unexpected status code: ${response.statusCode}');
    }
  } catch (e) {
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
