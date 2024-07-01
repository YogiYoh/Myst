import 'package:http/http.dart' as http;
import 'dart:convert';


class Profile {
  final String profileId;
  final String cuteName;
  final bool current;
  final int lastSave;
  final Map<String, dynamic> raw;
  final Map<String, dynamic> items;
  final Map<String, dynamic> data;
  final String id;
  final String category;
  final int damage;

  Profile({
    required this.profileId,
    required this.cuteName,
    required this.current,
    required this.lastSave,
    required this.raw,
    required this.items,
    required this.data,
    required this.id,
    required this.category,
    required this.damage,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      profileId: json['profile_id'],
      cuteName: json['cute_name'],
      current: json['current'],
      lastSave: json['last_save'],
      raw: json['raw'],
      items: json['items'],
      data: json['data'],
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      damage: json['damage'] ?? 0,
    );
  }

  static Future<List<Profile>> fetchProfiles(String username) async {
    final response = await http.get(
      Uri.parse('https://sky.shiiyu.moe/api/v2/profile/$username'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Profile> tempProfiles = [];
      jsonData.forEach((profileId, profileData) {
        Profile profile = Profile.fromJson(profileData);
        tempProfiles.add(profile);
      });
      return tempProfiles;
    } else {
      return [];
    }
  }
}
