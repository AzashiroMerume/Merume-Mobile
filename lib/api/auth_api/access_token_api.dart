import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merume_mobile/other/api_config.dart';
import 'package:merume_mobile/other/exceptions.dart';

const storage = FlutterSecureStorage();

Future<String?> getNewAccessToken() async {
  final refreshToken = await storage.read(key: 'refreshToken');

  if (refreshToken == null) {
    return null;
  }

  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    throw NetworkException('No internet connection');
  }

  try {
    final response = await http.get(
      Uri.parse('${ConfigAPI.baseURL}auth/refresh'),
      headers: {
        'refresh_token': refreshToken,
      },
    );

    if (kDebugMode) {
      print("Status code: ${response.statusCode}");
    }

    switch (response.statusCode) {
      case 201:
        final responseData = json.decode(response.body);
        await storage.write(key: 'accessToken', value: responseData['token']);
        return responseData['token'];
      case 400:
        throw ServerException('Internal server error');
      case 401:
        /*  final responseData = json.decode(response.body);
        if (responseData['error_message'] == 'Expired') { */
        await storage.delete(key: 'accessToken');
        await storage.delete(key: 'refreshToken');
        throw TokenErrorException('Token expired');
      /* } else {
          throw TokenErrorException('Token authentication error');
        } */
      case 500:
        throw ServerException('Internal server error');
      default:
        throw HttpException('Unexpected status code: ${response.statusCode}');
    }
  } on TimeoutException {
    throw NetworkException('Request timed out');
  } catch (e) {
    if (kDebugMode) {
      print("Refresh token error: $e");
    }

    rethrow;
  }
}
