import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:merume_mobile/api/auth_api/access_token_api.dart';
import 'package:merume_mobile/models/user_model.dart';
import 'package:merume_mobile/other/api_config.dart';
import 'package:merume_mobile/other/exceptions.dart';

Future<List<User>> getChannelFollowers(String channelId) async {
  final accessToken = await storage.read(key: 'accessToken');
  try {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkException('No internet connection');
    }
    final response = await http.get(
      Uri.parse('${ConfigAPI.baseURL}channels/$channelId/followers'),
      headers: {
        'Content-Type': 'application/json',
        'access_token': '$accessToken'
      },
    );

    switch (response.statusCode) {
      case 200:
        final responseData = jsonDecode(response.body);
        final followersData = responseData['data'] as List<dynamic>;
        final List<User> fetchedFollowers = followersData.map((follower) {
          return User.fromJson(follower);
        }).toList();
        return fetchedFollowers;
      case 401:
        try {
          final newAccessToken =
              await getNewAccessToken(); // Get a new access token
          if (newAccessToken != null) {
            await storage.write(key: 'accessToken', value: newAccessToken);
            return await getChannelFollowers(
                channelId); // Retry with the new access token
          } else {
            throw TokenErrorException('Token authentication error');
          }
        } catch (e) {
          rethrow;
        }

      case 404:
        throw HttpException('Data not found');
      case 500:
        throw HttpException('Internal server error');
      default:
        throw HttpException('Unexpected status code: ${response.statusCode}');
    }
  } on SocketException {
    throw NetworkException('No internet connection');
  } catch (e) {
    if (kDebugMode) {
      print('Error in channel_followers_api: $e');
    }

    rethrow;
  }
}
