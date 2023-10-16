import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../exceptions.dart';

const storage = FlutterSecureStorage();

Future<void> newChannel(String name, String channelType, String description,
    List<String> categories, String? baseImage) async {
  final authToken = await storage.read(key: 'authToken');

  try {
    final response = await http.post(
      Uri.parse('http://localhost:8081/users/channels/new'),
      body: json.encode({
        'name': name,
        'channel_type': channelType,
        'description': description,
        'categories': categories,
        'base_image': baseImage
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
      rethrow; // Rethrow the caught exception
    }
  }
}
