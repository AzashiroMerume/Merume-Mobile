import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merume_mobile/api/auth_api/access_token_api.dart';
import 'package:merume_mobile/constants/api_config.dart';
import 'package:merume_mobile/constants/exceptions.dart';
import 'package:merume_mobile/models/channel_model.dart';

const storage = FlutterSecureStorage();

Future<void> newChannel(
    ChallengeType challengeType,
    String name,
    int? challangeGoal,
    VisibilityType visibility,
    String description,
    List<String> categories,
    String? channelPfpLink) async {
  final accessToken = await storage.read(key: 'accessToken');

  try {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkException('No internet connection');
    }

    final response = await http.post(
      Uri.parse('${ConfigAPI.baseURL}user/channels/new'),
      body: json.encode({
        'name': name,
        'challenge_type': challengeType.name,
        'goal': challangeGoal,
        'visibility': visibility.name,
        'description': description,
        'categories': categories,
        'channel_pfp_link': channelPfpLink
      }),
      headers: {
        'Content-Type': 'application/json',
        'access_token': '$accessToken'
      },
    );

    if (kDebugMode) {
      print("Status code: ${response.statusCode}");
    }

    switch (response.statusCode) {
      case 201:
        break;
      case 401:
        final newAccessToken =
            await getNewAccessToken(); // Get a new access token
        if (newAccessToken != null) {
          await storage.write(key: 'accessToken', value: newAccessToken);
          return await newChannel(
              challengeType,
              name,
              challangeGoal,
              visibility,
              description,
              categories,
              channelPfpLink); // Retry with the new access token
        } else {
          throw TokenErrorException('Token authentication error');
        }
      case 422:
        throw UnprocessableEntityException('The request data is invalid');
      case 500:
        throw ServerException('The server encountered an unexpected error');
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
        print("Error in new_channel_api: $e");
      }

      rethrow; // Rethrow the caught exception
    }
  }
}
