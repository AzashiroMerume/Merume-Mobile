import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

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

  if (responseData['success'] != false) {
    await storage.write(key: 'authToken', value: responseData['data'][0]);
  } else {
    final errorMessage = responseData['error_message'];
    throw Exception(errorMessage);
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

  final responseData = json.decode(response.body);

  if (responseData['success'] != false) {
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

  final response = await http.get(
    Uri.parse('http://localhost:8081/auth'),
    headers: {
      'Authorization': authToken,
    },
  );

  final responseData = json.decode(response.body);

  if (responseData['success'] != false) {
    return true;
  } else {
    await storage.delete(key: 'authToken');
    return false;
  }
}
