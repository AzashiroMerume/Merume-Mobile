import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../exceptions.dart';

const storage = FlutterSecureStorage();

Future<void> createPost(
    String channelId, String postBody, List<String> postImages) async {
  final authToken = await storage.read(key: 'authToken');

  try {
    final response = await http.post(
      Uri.parse('http://localhost:8081/channels/${channelId}/post'),
      body: json.encode({
        'body': postBody,
        'images': postImages,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$authToken'
      },
    );

    print("Status code: ${response.statusCode}");

    switch (response.statusCode) {
      case 201:
        break;
      case 401:
        await storage.delete(key: 'authToken');
        throw TokenAuthException('Token authentication error');
      case 404:
        throw NotFoundException('The channel not found');
      case 409:
        throw PostAuthorConflictException('The user is not channel\'s owner');
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
      rethrow;
    }
  }
}
