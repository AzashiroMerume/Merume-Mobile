import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../exceptions.dart';

const storage = FlutterSecureStorage();

Future<String> register(
    String username, String nickname, String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost:8081/auth/register'),
      body: json.encode({
        'username': username,
        'nickname': nickname,
        'email': email,
        'password': password,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print("Status code: ${response.statusCode}");

    switch (response.statusCode) {
      case 201:
        final responseData = json.decode(response.body);
        await storage.write(key: 'authToken', value: responseData['token']);
        return responseData['user_id']['\$oid'];
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
      rethrow; // Rethrow the caught exception
    }
  }
}
