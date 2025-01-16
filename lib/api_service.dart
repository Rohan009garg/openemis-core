import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://demo.openemis.org/core/api/v4';
  static const String apiKey = 'apikeytest';

  /// Login API: Requires username, password, and API key.
  static Future<Map<String, dynamic>?> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {
        'username': username,
        'password': password,
        'api_key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }

  /// Fetch Key API: Uses the token for authorization.
  static Future<int?> getKey(String token, int openemisid) async {
    // print("andr aaya hu  service ke");
    final response = await http.get(
      Uri.parse('$baseUrl/users/openemis_id/$openemisid'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // print('response is in code: $response');
      final decode = json.decode(response.body);
      return decode['data'][0]['key'];
    }
    return null;
  }

  /// Fetch User Info API: Uses token and key to retrieve user information.
  static Future<Map<String, dynamic>?> getUserInfo(
      String token, int key) async {
    print("am inside");
    final response = await http.get(
      Uri.parse('$baseUrl/users/$key'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      print("taking data\n");
      print(response.body);
      return json.decode(response.body);
    }
    return null;
  }
}
