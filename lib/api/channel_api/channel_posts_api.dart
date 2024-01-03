import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:merume_mobile/api/auth_api/access_token_api.dart';
import 'package:merume_mobile/other/api_config.dart';
import 'package:merume_mobile/models/post_model.dart';
import 'package:merume_mobile/other/exceptions.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const storage = FlutterSecureStorage();

Stream<List<Post>> fetchChannelPosts(String channelId) async* {
  String channelUrl = '${ConfigAPI.wsURL}channels/$channelId/content';
  final accessToken = await storage.read(key: 'accessToken');
  final headers = {'access_token': '$accessToken'};

  final checkAuthResponse = await http.get(
    Uri.parse('${ConfigAPI.baseURL}auth'), // Check the authentication token
    headers: headers,
  );

  if (checkAuthResponse.statusCode == 401) {
    // Handle authentication error (token expired or invalid)
    final errorResponse = json.decode(checkAuthResponse.body);
    if (errorResponse.containsKey('error_message') &&
        errorResponse['error_message'] == 'Expired') {
      await storage.delete(key: 'accessToken');
      try {
        final accessToken = await getNewAccessToken();

        if (accessToken != null) {
          await FirebaseAuth.instance.signInWithCustomToken(accessToken);
        } else {
          throw TokenErrorException('Token auth error');
        }
      } catch (accessTokenError) {
        rethrow;
      }
    } else {
      throw TokenErrorException('Token auth error');
    }
  } /*  else if (checkAuthResponse.statusCode == 400 ||
      checkAuthResponse.statusCode == 500) {
    throw ServerException('The server encountered an unexpected error');
  }  */
  else {
    while (true) {
      try {
        final channel =
            IOWebSocketChannel.connect(Uri.parse(channelUrl), headers: headers);

        // Listen to incoming data from the WebSocket
        await for (var data in channel.stream) {
          final List<dynamic> postsJson = json.decode(data);
          final posts = postsJson.map((json) => Post.fromJson(json)).toList();
          yield posts;
        }

        await channel.sink.close();
      } catch (e) {
        if (kDebugMode) {
          print('WebSocket error: $e');
        }

        if (e is WebSocketChannelException) {
          print('Websocket channel exception: ${e.message}');
        }

        await Future.delayed(const Duration(seconds: 5));
      }
    }
  }
}
