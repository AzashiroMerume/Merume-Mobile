import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merume_mobile/other/api_config.dart';
import 'package:merume_mobile/screens/main/components/enums.dart';
import '../../other/exceptions.dart';

const storage = FlutterSecureStorage();

Future<void> newChannel(
    ChannelType channelType,
    String name,
    String challangeGoal,
    String channelVisibility,
    String description,
    List<String> categories,
    String? channelProfilePictureUrl) async {
  final authToken = await storage.read(key: 'authToken');

  try {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkException('No internet connection');
    }

    final response = await http.post(
      Uri.parse('${ConfigAPI.baseURL}users/channels/new'),
      body: json.encode({
        'channel_type': channelType.toString(),
        'name': name,
        'goal': int.tryParse(challangeGoal) ?? 0,
        'channel_visibility': channelVisibility,
        'description': description,
        'categories': categories,
        'channel_profile_picture_url': channelProfilePictureUrl
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
