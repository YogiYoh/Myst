import 'dart:convert'; // Import the dart:convert library to work with JSON data
import 'package:http/http.dart' as http; // Import the http package to make HTTP requests
import '../models/profile.dart'; // Import your Profile model

class ApiService {

  static const String baseUrl = 'https://sky.shiiyu.moe/api/v2/profile';
   List<String> otherNames = []; 

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

        // Collect all cuteNames 
        for(var profileIdKey in profiles.keys){
          final profileData = profiles[profileIdKey]; // Get the profile data
          otherNames.add(profileData['cute_name']); 
          print('Adding ${profileData['cute_name']} to otherNames');
        }


        // Second pass: Find the current profile
        for(var profileIdKey in profiles.keys){
          final profileData = profiles[profileIdKey]; // Get the profile data
          if(profileData['current'] == true){
            // Remove the current profile from otherNames
            otherNames.remove(profileData['cute_name']);
            otherNames.insert(0, profileData['cute_name']);
            // Debugging output for otherNames before returning
            print('Current profile found, otherNames after removal: $otherNames');
            return Profile.fromJson(profileData, otherNames);
          }
        }
        // Check if the response contains the 'data' key and if it's not null
          print('Profile data is null or missing: ${response.body}');
          throw Exception('Profile data is null or missing');

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


   Future<Profile>  newProfile(String username, String cutename) async {
    // Make an HTTP GET request to the API endpoint
    final response = await http.get(Uri.parse('$baseUrl/$username'));

    // Check if the HTTP request was successful
    if (response.statusCode == 200) {
      // Print the response body for debugging
      try {
        // Try to decode the JSON response
        final jsonData = json.decode(response.body);
        final profiles = jsonData['profiles'];
        for(var profileIdKey in profiles.keys){
          final profileData = profiles[profileIdKey]; // Get the profile data



          if(profileData['current'] == cutename){
            return Profile.fromJson(profileData, otherNames);
          }else{
            otherNames.add(profileData['cute_name']); 
          }
        }
        // Check if the response contains the 'data' key and if it's not null
          print('Profile data is null or missing: ${response.body}');
          throw Exception('Profile data is null or missing');

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