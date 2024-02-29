import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merume_mobile/api/auth_api/access_token_api.dart';
import 'package:merume_mobile/utils/api_config.dart';
import '../../../utils/exceptions.dart';
import '../../../models/channel_model.dart';

const storage = FlutterSecureStorage();

Future<List<Channel>> fetchRecommendations(int page, {int limit = 10}) async {
  const baseUrl = '${ConfigAPI.baseURL}user/recommendations';
  final accessToken = await storage.read(key: 'accessToken');
  final headers = {'access_token': '$accessToken'};

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
        final newAccessToken =
            await getNewAccessToken(); // Get a new access token
        if (newAccessToken != null) {
          await storage.write(key: 'accessToken', value: newAccessToken);
          return await fetchRecommendations(page,
              limit: limit); // Retry with the new access token
        } else {
          throw TokenErrorException('Token authentication error');
        }

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
      if (kDebugMode) {
        print("Error in recommendations_api: $e");
      }

      rethrow; // Rethrow the caught exception
    }
  }
}
