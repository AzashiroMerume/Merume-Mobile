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
      case HttpStatus.created:
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          await storage.write(key: 'authToken', value: responseData['data'][0]);
        }
        break;
      case HttpStatus.badRequest:
        final responseData = json.decode(response.body);
        throw RegistrationException(responseData['error_message']);
      case HttpStatus.requestEntityTooLarge:
        throw ContentTooLargeException('The request payload is too large');
      case HttpStatus.unprocessableEntity:
        throw UnprocessableEntityException('The request data is invalid');
      case HttpStatus.internalServerError:
        throw ServerException('The server encountered an unexpected error');
      default:
        throw HttpException(
            'Received unexpected status code: ${response.statusCode}');
    }
  } on SocketException {
    throw NetworkException('Unable to connect to server');
  } on TimeoutException {
    throw TimeoutException('The server is taking too long to respond');
  } catch (e) {
    rethrow;
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
      case HttpStatus.ok:
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          await storage.write(key: 'authToken', value: responseData['data'][0]);
        }
        break;
      case HttpStatus.unauthorized:
        throw AuthenticationException('The email or password is incorrect');
      case HttpStatus.notFound:
        throw NotFoundException('The specified email address was not found');
      case HttpStatus.internalServerError:
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
      case HttpStatus.ok:
        return true;
      case HttpStatus.unauthorized:
        await storage.delete(key: 'authToken');
        throw TokenAuthException('Token authentication error');
      case HttpStatus.internalServerError:
        throw ServerException('Internal server error');
      default:
        throw HttpException('Unexpected status code: ${response.statusCode}');
    }
  } catch (e) {
    if (e is SocketException || e is TimeoutException || e is http.ClientException) {
      throw NetworkException('Network error');
    } else {
      throw http.ClientException;
    }
  }
}
