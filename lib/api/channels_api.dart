import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Channel>> fetchChannels() async {
  String url = 'localhost';
  try {
    final response = await http.get(Uri.parse('http://$url:8081/channels'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody['success'] == true) {
        final List<dynamic> channelsJson = responseBody['data'];
        return channelsJson.map((json) => Channel.fromJson(json)).toList();
      } else {
        print('Error occurred: ${responseBody['error_message']}');
        throw Exception(responseBody['error_message']);
      }
    } else {
      print('Error occurred: ${response.statusCode}');
      throw Exception('Failed to fetch channels');
    }
  } catch (error) {
    print('Error occurred: $error');
    throw Exception('Failed to fetch channels');
  }
}

class Channel {
  final String id;
  final String owner_id;
  final String name;
  final String description;
  final String base_image;

  const Channel({
    required this.id,
    required this.owner_id,
    required this.name,
    required this.description,
    required this.base_image,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['_id']['\$oid'] ?? '',
      owner_id: json['owner_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      base_image: json['base_image'] ?? '',
    );
  }
}
