import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:merume_mobile/other/api_config.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merume_mobile/api/components/get_headers_with_access_token_api.dart';

const storage = FlutterSecureStorage();

Future<IOWebSocketChannel> heartbeat() async {
  const heartbeatUrl = '${ConfigAPI.wsURL}user/heartbeat';
  late IOWebSocketChannel webSocketChannel;

  try {
    final headers = await getHeadersWithValidAccessToken();
    webSocketChannel = IOWebSocketChannel.connect(
      Uri.parse(heartbeatUrl),
      headers: headers,
    );

    // Send heartbeat messages periodically
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (webSocketChannel.closeCode == null) {
        timer.cancel();
      } else {
        webSocketChannel.sink.add(jsonEncode({'type': 'heartbeat'}));
      }
    });
  } catch (e) {
    if (kDebugMode) {
      print("Error in heartbeat: $e");
    }
  }

  return webSocketChannel;
}
