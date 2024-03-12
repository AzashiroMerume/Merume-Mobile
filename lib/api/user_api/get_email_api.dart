import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:merume_mobile/constants/api_config.dart';
import 'package:merume_mobile/constants/exceptions.dart';

Future<String> getEmailByNickname(String nickname) async {
  try {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw NetworkException('No internet connection');
    }

    final response = await http.post(
      Uri.parse('${ConfigAPI.baseURL}user/get_email'),
      body: json.encode({'nickname': nickname}),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (kDebugMode) {
      print("Status code: ${response.statusCode}");
    }

    switch (response.statusCode) {
      case 200:
        final responseData = json.decode(response.body);
        final email = responseData['email'];
        return email;
      case 404:
        throw NotFoundException(
            'The specified user was not found. Provide a valid nickname');
      case 422:
        throw UnprocessableEntityException('The request data is invalid');
      case 500:
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
      if (kDebugMode) {
        print("Error in get_email_api: $e");
      }

      rethrow; // Rethrow the caught exception
    }
  }
}
