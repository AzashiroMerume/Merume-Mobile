import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../exceptions.dart';

const storage = FlutterSecureStorage();

Future<bool> savePreferences(List<String> preferences) async {
  final authToken = await storage.read(key: 'authToken');

  if (authToken == null) {
    throw TokenAuthException('Token authentication error');
  }

  try {
    final response = await http.post(
      Uri.parse('http://localhost:8081/preferences'),
      body: json.encode({'preferences': preferences}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authToken,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      await storage.delete(key: 'authToken');
      throw TokenAuthException('Token authentication error');
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
  }
}

Future<List<String>?> getPreferences() async {
  final authToken = await storage.read(key: 'authToken');

  if (authToken == null) {
    throw TokenAuthException('Token authentication error');
  }

  try {
    final response = await http.get(
      Uri.parse('http://localhost:8081/preferences'),
      headers: {
        'Authorization': authToken,
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
      await storage.delete(key: 'authToken');
      throw TokenAuthException('Token authentication error');
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
  }
}
