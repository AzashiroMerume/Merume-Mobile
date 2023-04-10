import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../exceptions.dart';

const storage = FlutterSecureStorage();

Future<void> register(String nickname, String email, String password) async {
  try {
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

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      if (responseData['success'] == true) {
        await storage.write(key: 'authToken', value: responseData['data'][0]);
      }
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      throw RegistrationException(responseData['error_message']);
    } else if (response.statusCode >= 500) {
      throw ServerException('Internal server error');
    } else {
      throw HttpException('Unexpected status code: ${response.statusCode}');
    }
  } on SocketException {
    throw NetworkException('Network error');
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

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        await storage.write(key: 'authToken', value: responseData['data'][0]);
      } else {
        final errorMessage = responseData['error_message'];
        throw AuthenticationException(errorMessage);
      }
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      throw AuthenticationException('Invalid email or password');
    } else if (response.statusCode == 404) {
      throw NotFoundException('Email not found');
    } else if (response.statusCode >= 500) {
      throw ServerException('Internal server error');
    } else {
      throw HttpException('Unexpected status code: ${response.statusCode}');
    }
  } on SocketException {
    throw NetworkException('Network error');
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
      throw AuthenticationException('');
    } else if (response.statusCode >= 500) {
      throw InternalServerErrorException('Internal server error');
    } else {
      throw HttpException('Unexpected status code: ${response.statusCode}');
    }
  } on SocketException {
    throw NetworkException('Network error');
  }
}
