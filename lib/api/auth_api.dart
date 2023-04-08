import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../exceptions.dart';

const storage = FlutterSecureStorage();

Future<void> register(String nickname, String email, String password) async {
  final response = await http.post(
    Uri.parse('http://localhost:8081/auth/register'),
    body: json.encode({
      'nickname': nickname,
      'email': email,
      'password': password,
    }),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  final responseData = json.decode(response.body);

  if (responseData['success'] == true && responseData['data'] != null) {
    await storage.write(key: 'authToken', value: responseData['data'][0]);
  } else {
    final errorMessage = responseData['error_message'] ?? 'Unknown error';
    throw RegistrationException(errorMessage);
  }
}

Future<void> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://localhost:8081/auth/login'),
    body: json.encode({'email': email, 'password': password}),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode >= 400) {
    throw HttpException('Unexpected status code: ${response.statusCode}');
  }

  final responseData = json.decode(response.body);

  if (responseData['success'] == true) {
    await storage.write(key: 'authToken', value: responseData['data'][0]);
  } else {
    final errorMessage = responseData['error_message'];
    throw Exception(errorMessage);
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

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      await storage.delete(key: 'authToken');
      throw AuthenticationException('Invalid authentication token');
    } else if (response.statusCode == 500) {
      throw ServerException('Server error: ${response.statusCode}');
    } else {
      throw HttpException('HTTP error: ${response.statusCode}');
    }
  } on SocketException catch (e) {
    throw NetworkException('Network error: $e');
  }
}
