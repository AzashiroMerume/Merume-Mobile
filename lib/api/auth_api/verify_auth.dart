import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../exceptions.dart';

const storage = FlutterSecureStorage();

Future<String?> verifyAuth() async {
  final authToken = await storage.read(key: 'authToken');

  if (authToken == null) {
    return null;
  }

  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    throw NetworkException('No internet connection');
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
      case 200:
        final responseData = json.decode(response.body);
        return responseData['user_id']['\$oid'];
      case 401:
        await storage.delete(key: 'authToken');
        throw TokenAuthException('Token authentication error');
      case 500:
        throw ServerException('Internal server error');
      default:
        throw HttpException('Unexpected status code: ${response.statusCode}');
    }
  } on TimeoutException {
    throw NetworkException('Request timed out');
  } catch (e) {
    rethrow;
  }
}
