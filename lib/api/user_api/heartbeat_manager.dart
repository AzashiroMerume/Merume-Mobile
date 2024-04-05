import 'package:web_socket_channel/io.dart';
import 'dart:async';
import 'dart:convert';
import 'package:merume_mobile/constants/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merume_mobile/api/components/get_headers_with_access_token_api.dart';

const storage = FlutterSecureStorage();

class HeartbeatManager {
  static HeartbeatManager? _instance;
  late IOWebSocketChannel _webSocketChannel;
  late Timer _timer;

  factory HeartbeatManager() {
    _instance ??= HeartbeatManager._();
    return _instance!;
  }

  HeartbeatManager._() {
    _initializeWebSocket();
  }

  void _initializeWebSocket() async {
    const heartbeatUrl = '${ConfigAPI.wsURL}user/heartbeat';
    final headers = await getHeaderWithValidAccessToken();
    _webSocketChannel = IOWebSocketChannel.connect(
      Uri.parse(heartbeatUrl),
      headers: headers,
    );

    // Send heartbeat messages periodically
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (_webSocketChannel.closeCode != null) {
        _timer.cancel();
      } else {
        _webSocketChannel.sink.add(jsonEncode({'type': 'heartbeat'}));
      }
    });

    // Listen for WebSocket close event
    _webSocketChannel.stream.listen((dynamic message) {
      if (_webSocketChannel.closeCode != null) {
        _timer.cancel();
      }
    });
  }

  void close() {
    _webSocketChannel.sink.close();
    _timer.cancel();
  }
}
