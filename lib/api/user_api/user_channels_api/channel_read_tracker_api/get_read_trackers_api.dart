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
import 'package:merume_mobile/models/read_tracker_model.dart';

const storage = FlutterSecureStorage();

Future<List<ReadTracker>> getReadTrackers() async {
  final accessToken = await storage.read(key: 'accessToken');

  try {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkException('No internet connection');
    }

    final response = await http.get(
      Uri.parse('${ConfigAPI.baseURL}user/channels/read_trackers'),
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
        final responseData = jsonDecode(response.body);
        final data = responseData['data'] as Map<String, dynamic>;

        // Convert the data to List<ReadTracker?>
        final List<ReadTracker> readTrackersList = data.entries.map((entry) {
          final channelId = entry.key;
          final unreadCount = entry.value as int;
          return ReadTracker(channelId: channelId, unreadCount: unreadCount);
        }).toList();

        return readTrackersList;
      case 401:
        final newAccessToken =
            await getNewAccessToken(); // Get a new access token
        if (newAccessToken != null) {
          await storage.write(key: 'accessToken', value: newAccessToken);
          return await getReadTrackers(); // Retry with the new access token
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
        print("Error in get_read_trackers_api: $e");
      }

      rethrow; // Rethrow the caught exception
    }
  }
}
