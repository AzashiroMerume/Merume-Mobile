import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../exceptions.dart';

const storage = FlutterSecureStorage();

Future<void> register(
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
        break;
      case 400:
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

Future<void> login(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost:8081/auth/login'),
      body: json.encode({'email': email, 'password': password}),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print("Status code: ${response.statusCode}");

    switch (response.statusCode) {
      case 200:
        final responseData = json.decode(response.body);
        await storage.write(key: 'authToken', value: responseData['token']);
        break;
      case 401:
        throw AuthenticationException('The email or password is incorrect');
      case 404:
        throw NotFoundException('The specified email address was not found');
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

Future<bool> verifyAuth() async {
  final authToken = await storage.read(key: 'authToken');

  if (authToken == null) {
    return false;
  }

  try {
    final response = await http.get(
      Uri.parse('http://localhost:8081/auth'),
      headers: {
        'Authorization': authToken,
      },
    );

    print("Status code: ${response.statusCode}");

    switch (response.statusCode) {
      case 200:
        return true;
      case 401:
        await storage.delete(key: 'authToken');
        throw TokenAuthException('Token authentication error');
      case 500:
        throw ServerException('Internal server error');
      default:
        throw HttpException('Unexpected status code: ${response.statusCode}');
    }
  } on SocketException {
    throw NetworkException('Network error');
  } on TimeoutException {
    throw NetworkException('Request timed out');
  } catch (e) {
    rethrow;
  }
}
