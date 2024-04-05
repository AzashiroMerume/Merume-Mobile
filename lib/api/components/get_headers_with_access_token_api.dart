import 'package:merume_mobile/api/auth_api/access_token_api.dart';
import 'package:merume_mobile/constants/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:merume_mobile/constants/exceptions.dart';

Future<Map<String, String>> getHeaderWithValidAccessToken() async {
  final accessToken = await storage.read(key: 'accessToken');

  final headers = {'access_token': '$accessToken'};

  final checkAuthResponse = await http.get(
    Uri.parse('${ConfigAPI.baseURL}auth'), // Check the authentication token
    headers: headers,
  );

  if (checkAuthResponse.statusCode == 401) {
    try {
      final newAccessToken = await getNewAccessToken();

      if (newAccessToken != null) {
        headers['access_token'] = newAccessToken;
      } else {
        throw TokenErrorException('Token auth error');
      }
    } catch (accessTokenError) {
      rethrow;
    }
  }

  return headers;
}
