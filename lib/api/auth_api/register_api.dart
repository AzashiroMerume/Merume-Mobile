import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merume_mobile/other/api_config.dart';
import 'package:merume_mobile/models/user_model.dart';
import '../../other/exceptions.dart';

const storage = FlutterSecureStorage();

Future<User> register(String username, String nickname, String email,
    String password, String firebaseUserId) async {
  try {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkException('No internet connection');
    }

    final response = await http.post(
      Uri.parse('${ConfigAPI.baseURL}auth/register'),
      body: json.encode({
        'username': username,
        'nickname': nickname,
        'email': email,
        'password': password,
        'firebase_user_id': firebaseUserId
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (kDebugMode) {
      print("Status code: ${response.statusCode}");
    }

    switch (response.statusCode) {
      case 201:
        final responseData = json.decode(response.body);

        await storage.write(key: 'accessToken', value: responseData['token']);
        await storage.write(
            key: 'refreshToken', value: responseData['refresh_token']);
        await storage.write(
            key: 'userInfo', value: json.encode(responseData['user_info']));

        final userInfo = User.fromJson(responseData['user_info']);

        return userInfo;
      case 409:
        final responseData = json.decode(response.body);
        throw RegistrationException(responseData['error_message']);
      case 413:
        throw ContentTooLargeException('The request payload is too large');
      case 422:
        throw UnprocessableEntityException('The request data is invalid');
      case 500:
        throw ServerException('The server encountered an unexpected error');
      default:
        throw HttpException(
            'Received an unexpected status code: ${response.statusCode}');
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
        print(e);
      }

      rethrow; // Rethrow the caught exception
    }
  }
}
