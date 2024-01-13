import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merume_mobile/api/auth_api/access_token_api.dart';
import 'package:merume_mobile/other/api_config.dart';
import '../../../other/exceptions.dart';

const storage = FlutterSecureStorage();

Future<bool> savePreferences(List<String> preferences) async {
  final accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw TokenErrorException('Token authentication error');
  }

  try {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkException('No internet connection');
    }

    final response = await http.post(
      Uri.parse('${ConfigAPI.baseURL}user/preferences'),
      body: json.encode({'preferences': preferences}),
      headers: {
        'Content-Type': 'application/json',
        'access_token': accessToken,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      final responseData = json.decode(response.body);
      if (responseData['error_message'] == 'Expired') {
        final newAccessToken =
            await getNewAccessToken(); // Get a new access token
        if (newAccessToken != null) {
          await storage.write(key: 'accessToken', value: newAccessToken);
          return await savePreferences(
              preferences); // Retry with the new access token
        } else {
          throw TokenErrorException('Token authentication error');
        }
      } else {
        throw TokenErrorException('Token authentication error');
      }
    } else if (response.statusCode == 413) {
      throw ContentTooLargeException('Content too large');
    } else if (response.statusCode == 422) {
      throw UnprocessableEntityException('Invalid input data');
    } else if (response.statusCode >= 500) {
      throw ServerException('Internal server error');
    } else {
      throw HttpException('Unexpected status code: ${response.statusCode}');
    }
  } on SocketException {
    throw NetworkException('Network error');
  } catch (e) {
    if (kDebugMode) {
      print("Error in save_preferences_api: $e");
    }

    rethrow;
  }
}

Future<List<String>?> getPreferences() async {
  final accessToken = await storage.read(key: 'accessToken');

  if (accessToken == null) {
    throw TokenErrorException('Token authentication error');
  }

  try {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkException('No internet connection');
    }

    final response = await http.get(
      Uri.parse('http://localhost:8081/preferences'),
      headers: {
        'access_token': accessToken,
      },
    );

    if (response.statusCode == 200) {
      // Parse the response JSON into a map
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final data = responseData['data'];

        if (data != null) {
          List<String> preferences = List<String>.from(data);
          return preferences;
        } else {
          return null;
        }
      } else {
        throw Exception('Preferences retrieval failed');
      }
    } else if (response.statusCode == 401) {
      throw TokenErrorException('Token authentication error');
    } else if (response.statusCode == 413) {
      throw ContentTooLargeException('Content too large');
    } else if (response.statusCode == 422) {
      throw UnprocessableEntityException('Invalid input data');
    } else if (response.statusCode >= 500) {
      throw ServerException('Internal server error');
    } else {
      throw HttpException('Unexpected status code: ${response.statusCode}');
    }
  } on SocketException {
    throw NetworkException('Network error');
  } catch (e) {
    if (kDebugMode) {
      print("Error in get_preferences_api: $e");
    }

    rethrow;
  }
}
