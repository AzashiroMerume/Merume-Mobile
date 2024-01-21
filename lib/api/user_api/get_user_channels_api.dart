import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:merume_mobile/models/channel_model.dart';
import 'package:merume_mobile/other/api_config.dart';
import 'package:merume_mobile/other/exceptions.dart';

const storage = FlutterSecureStorage();

Future<List<Channel>?> getUserChannels(String userId) async {
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
      Uri.parse('${ConfigAPI.baseURL}user/$userId'),
      headers: {
        'access_token': accessToken,
      },
    );

    if (response.statusCode == 200) {
      // Parse the response JSON into a map
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['error'] == null) {
        final data = responseData['channels'];

        if (data != null) {
          List<Channel> channels = List<Channel>.from(data);
          return channels;
        } else {
          return null;
        }
      } else {
        throw ServerException('Data error');
      }
    } else if (response.statusCode == 401) {
      throw TokenErrorException('Token authentication error');
    } else if (response.statusCode == 413) {
      throw ContentTooLargeException('Content too large');
    } else if (response.statusCode >= 500) {
      throw ServerException('Internal server error');
    } else {
      throw HttpException('Unexpected status code: ${response.statusCode}');
    }
  } on SocketException {
    throw NetworkException('Network error');
  } catch (e) {
    if (kDebugMode) {
      print("Error in getUserChannels API: $e");
    }

    rethrow;
  }
}
