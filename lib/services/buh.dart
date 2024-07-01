import 'dart:convert'; // Import the dart:convert library to work with JSON data
import 'package:http/http.dart' as http; // Import the http package to make HTTP requests
import '../models/profile.dart'; // Import your Profile model (ensure this is correctly implemented)

class ApiService {
  static const String baseUrl = 'https://sky.shiiyu.moe/api/v2/profile';

  Future<Profile> fetchProfile(String username) async {
    // Make an HTTP GET request to the API endpoint
    final response = await http.get(Uri.parse('$baseUrl/$username'));

    // Check if the HTTP request was successful
    if (response.statusCode == 200) {
      try {
        // Decode the JSON response
        final jsonData = json.decode(response.body);

        // Assuming the structure is {"profiles": {...}}
        final profiles = jsonData['profiles'];
        final profileIdKey = profiles.keys.first; // Get the first profile ID
        final profileData = profiles[profileIdKey]; // Get the profile data

        // Create a Profile object from the JSON data and return it
        return Profile.fromJson(profileData);
      } catch (e) {
        // Handle any exceptions that occur during JSON decoding or data extraction
        print('Failed to decode JSON: $e');
        throw Exception('Failed to decode JSON');
      }
    } else {
      // Print an error message and throw an exception if the HTTP request fails
      print('Failed to load profile: ${response.statusCode}');
      throw Exception('Failed to load profile');
    }
  }
}

// Example of your Profile model
class Profile {
  final String profileId;
  final String cuteName;
  final String gameMode;
  final bool current;

  Profile({
    required this.profileId,
    required this.cuteName,
    required this.gameMode,
    required this.current,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      profileId: json['profile_id'],
      cuteName: json['cute_name'],
      gameMode: json['game_mode'],
      current: json['current'],
    );
  }
}

void main() async {
  ApiService apiService = ApiService();
  Profile profile = await apiService.fetchProfile('MysticPoo');
  print('Profile ID: ${profile.profileId}');
  print('Cute Name: ${profile.cuteName}');
  print('Game Mode: ${profile.gameMode}');
  print('Current: ${profile.current}');
}
