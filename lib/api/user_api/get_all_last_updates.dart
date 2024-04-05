import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:merume_mobile/constants/api_config.dart';
import 'package:merume_mobile/models/last_update_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merume_mobile/api/components/get_headers_with_access_token_api.dart';

const storage = FlutterSecureStorage();

Stream<LastUpdate> fetchAllLastUpdates() async* {
  const url = '${ConfigAPI.wsURL}user/last_updates';

  while (true) {
    try {
      final headers = await getHeaderWithValidAccessToken();

      final conn = IOWebSocketChannel.connect(
        Uri.parse(url),
        headers: headers,
      );

      // Listen to incoming data from the WebSocket
      await for (var data in conn.stream) {
        final LastUpdate lastUpdate = LastUpdate.fromJson((json.decode(data)));
        yield lastUpdate;
      }

      await conn.sink.close();
    } catch (e) {
      if (kDebugMode) {
        print("Error in all_last_updates_stream: $e");
      }

      rethrow;
    }
  }
}
