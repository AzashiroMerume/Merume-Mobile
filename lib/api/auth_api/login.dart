import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merume_mobile/models/user_info_model.dart';

import '../../exceptions.dart';

const storage = FlutterSecureStorage();

Future<UserInfo> login(String identifier, String password, bool byEmail) async {
  try {
    final response = await http.post(
      Uri.parse('http://localhost:8081/auth/login'),
      body: json.encode({
        'identifier': identifier,
        'password': password,
        'by_email': byEmail,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print("Status code: ${response.statusCode}");

    switch (response.statusCode) {
      case 200:
        final responseData = json.decode(response.body);
        await storage.write(key: 'authToken', value: responseData['token']);
        final userInfo = UserInfo.fromJson(responseData);
        return userInfo;
      case 401:
        throw AuthenticationException(
            'The identifier or password is incorrect');
      case 404:
        throw NotFoundException(
            'The specified identifier address was not found');
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
