import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile.dart';

class ApiService {
  static const String baseUrl = 'https://sky.shiiyu.moe/api/v2/profile';

  Future<List<Profile>> fetchProfiles(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/$username'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      List<Profile> profiles = jsonResponse.map((data) => Profile.fromJson(data)).toList();
      return profiles;
    } else {
      throw Exception('Failed to load profiles');
    }
  }
}
