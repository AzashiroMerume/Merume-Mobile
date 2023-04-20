import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../exceptions.dart';

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
