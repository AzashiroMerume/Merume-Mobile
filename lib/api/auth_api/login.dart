import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merume_mobile/other/api_config.dart';
import 'package:merume_mobile/models/user_model.dart';
import '../../other/exceptions.dart';

const storage = FlutterSecureStorage();

Future<User> login(String identifier, String password, bool byEmail,
    String firebaseUserId) async {
  try {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkException('No internet connection');
    }

    final response = await http.post(
      Uri.parse('${ConfigAPI.baseURL}auth/login'),
      body: json.encode({
        'identifier': identifier,
        'password': password,
        'by_email': byEmail,
        'firebase_user_id': firebaseUserId
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
        final userInfo = User.fromJson(responseData['user_info']);
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
