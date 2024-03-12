import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merume_mobile/api/auth_api/access_token_api.dart';
import 'package:merume_mobile/constants/api_config.dart';
import '../../constants/exceptions.dart';

const storage = FlutterSecureStorage();

Future<void> createPost(String channelId, String postId, String postBody,
    List<String>? postImages) async {
  if (channelId.isEmpty ||
      postId.isEmpty ||
      (postBody.isEmpty && (postImages == null || postImages.isEmpty))) {
    throw UnprocessableEntityException('The request data is invalid');
  }

  final accessToken = await storage.read(key: 'accessToken');

  try {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkException('No internet connection');
    }

    final response = await http.post(
      Uri.parse('${ConfigAPI.baseURL}channels/$channelId/post'),
      body: json.encode({
        'id': postId,
        'body': postBody,
        'images': postImages,
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
          return await createPost(channelId, postId, postBody,
              postImages); // Retry with the new access token
        } else {
          throw TokenErrorException('Token authentication error');
        }
      case 403:
        throw PostAuthorConflictException('The user is not channel\'s owner');
      case 404:
        throw NotFoundException('The channel not found');
      case 413:
        throw ContentTooLargeException('The request payload is too large');
      case 422:
        throw UnprocessableEntityException('The request data is invalid');
      case 500:
        throw ServerException('The server encountered an unexpected error');
      default:
        throw HttpException(
            'Received unexpected status code: ${response.statusCode}');
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
        print('Error in create_post_api: $e');
      }

      rethrow;
    }
  }
}
