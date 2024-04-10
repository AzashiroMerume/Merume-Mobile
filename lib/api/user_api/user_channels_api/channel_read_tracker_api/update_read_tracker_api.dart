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

const storage = FlutterSecureStorage();

Future<void> updateReadTracker(
    String channelId, int? unreadPostsCount, String? lastReadPostId) async {
  final accessToken = await storage.read(key: 'accessToken');

  try {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkException('No internet connection');
    }

    final response = await http.post(
      Uri.parse('${ConfigAPI.baseURL}user/channels/read_trackers/$channelId'),
      body: json.encode({
        'unread_posts_count': unreadPostsCount,
        'last_read_post_id': lastReadPostId
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
      case 200:
      case 201:
        break;
      case 401:
        final newAccessToken =
            await getNewAccessToken(); // Get a new access token
        if (newAccessToken != null) {
          await storage.write(key: 'accessToken', value: newAccessToken);
          return await updateReadTracker(channelId, unreadPostsCount,
              lastReadPostId); // Retry with the new access token
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
