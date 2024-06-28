import 'dart:convert'; // Import the dart:convert library to work with JSON data
import 'package:http/http.dart' as http; // Import the http package to make HTTP requests
import '../models/profile.dart'; // Import your Profile model

class ApiService {
  static const String baseUrl = 'https://sky.shiiyu.moe/api/v2/profile';

  Future<Profile> fetchProfile(String username) async {
    // Make an HTTP GET request to the API endpoint
    final response = await http.get(Uri.parse('$baseUrl/$username'));

    // Check if the HTTP request was successful
    if (response.statusCode == 200) {
      // Print the response body for debugging

      try {
        // Try to decode the JSON response
        final jsonData = json.decode(response.body);
        final profiles = jsonData['profiles'];
        final profileIdKey = profiles.keys.first; // Get the first profile ID
        final profileData = profiles[profileIdKey]; // Get the profile data
        // Check if the response contains the 'data' key and if it's not null
        if(profileData['current'] == true){
            return Profile.fromJson(profileData);
        }else{
          print('Profile data is null or missing: ${response.body}');
          throw Exception('Profile data is null or missing');
        }
      
      } catch (e) {
        // Extract profile data using the dynamic key
        // Print an error message and throw an exception if JSON decoding fails

        final jsonData = json.decode(response.body);
        final profileId = jsonData.keys.first; // Potential error if no keys
        final profileData = jsonData[profileId]; // Potential error if key not present or data is not in expected format
        
        String cute_name = profileData['cute_name']; 

        print(cute_name); 

        throw Exception('Failed to decode JSON');
      }
    } else {
      // Print an error message and throw an exception if the HTTP request fails
      print('Failed to load profile: ${response.statusCode}');
      throw Exception('Failed to load profile');
    }
  }
}
