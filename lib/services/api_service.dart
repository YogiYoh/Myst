import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile.dart';

class ApiService {
  static const String baseUrl = 'https://sky.shiiyu.moe/api/v2/profile';

  Future<Profile> fetchProfile(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/$username'));

    if (response.statusCode == 200) {
      // Print the response body for debugging
      print('Response body: ${response.body}');

      try {
        final jsonData = json.decode(response.body);
        if (jsonData.containsKey('data') && jsonData['data'] != null) {
          return Profile.fromJson(jsonData['data']);
        } else {
          print('Profile data is null or missing: ${response.body}');
          throw Exception('Profile data is null or missing');
        }
      } catch (e) {
        print('Failed to decode JSON: ${response.body}');
        throw Exception('Failed to decode JSON');
      }
    } else {
      print('Failed to load profile: ${response.statusCode}');
      throw Exception('Failed to load profile');
    }
  }
}
